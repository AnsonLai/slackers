import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'user.dart';
import 'absence.dart';

class DatabaseClient {
  DatabaseClient._();
  static final DatabaseClient db = DatabaseClient._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await create();
    return _database;
  }

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "slackersDB.db");

    _database = await openDatabase(dbPath,
        version: 1, onOpen: (db) {}, onCreate: this._create);
    return _database;
  }

  Future _create(Database db, int version) async {
    await db.execute("""
      CREATE TABLE User (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    """);
    await db.execute("""
      CREATE TABLE Absence (
        id INTEGER PRIMARY KEY,
        date INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user (id)
          ON DELETE CASCADE ON UPDATE CASCADE
      )
    """);
  }

  // CREATE and UPDATE
  Future<User> upsertUser(User user) async {
    final db = await database;

    if (user.id == null) {
      user.id = await db.insert("User", user.toMap());
    } else {
      await db
          .update("User", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    }

    return user;
  }

  Future<Absence> upsertAbsence(Absence absence) async {
    final db = await database;

    if (absence.id == null) {
      absence.id = await db.insert("Absence", absence.toMap());
    } else {
      await db.update("Absence", absence.toMap(),
          where: "id = ?", whereArgs: [absence.id]);
    }

    return absence;
  }

  // READ
  // Get all users
  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("User");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  // Get absences associated with user
  Future<List<Absence>> getAbsencesFromUser(User user) async {
    final db = await database;
    int user_id = user.id;
    var res =
        await db.query("Absence", where: "user_id = ?", whereArgs: [user_id]);
    List<Absence> list =
        res.isNotEmpty ? res.map((c) => Absence.fromMap(c)).toList() : [];
    return list;
  }

  // DELETE
  deleteUser(User user) async {
    final db = await database;
    db.delete("Absence", where: "user_id = ?", whereArgs: [user.id]);
    db.delete("User", where: "id = ?", whereArgs: [user.id]);
  }

  deleteAbsence(User user, DateTime dateTime) async {
    final db = await database;

    int user_id = user.id;
    int _startMS = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    int _endMS = _startMS + 86399999;
    db.rawDelete(
        'DELETE FROM Absence WHERE user_id = ? AND date BETWEEN ? and ?',
        [user_id.toString(), _startMS.toString(), _endMS.toString()]);
  }

  // CAROUSEL CALENDAR SPECIFIC FUNCTIONS
  // Create markedDatesMap from query
  Future<EventList<Event>> getAbsencesMapFromUser(User user) async {
    EventList<Event> _markedDateMap = new EventList();
    Widget _eventIcon = new Container(
      decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: Colors.red, width: 2.0)),
      child: new Icon(
        Icons.cancel,
        color: Colors.white,
      ),
    );

    final db = await database;
    int user_id = user.id;
    var res =
        await db.query("Absence", where: "user_id = ?", whereArgs: [user_id]);
    List<Absence> list =
        res.isNotEmpty ? res.map((c) => Absence.fromMap(c)).toList() : [];

    for (var i = 0; i < list.length; i++) {
      DateTime _dateTimeFull =
          DateTime.fromMillisecondsSinceEpoch(list[i].date);
      DateTime _dateTime =
          DateTime(_dateTimeFull.year, _dateTimeFull.month, _dateTimeFull.day);
      _markedDateMap.add(_dateTime,
          Event(date: _dateTime, title: user.name, icon: _eventIcon));
    }

    return _markedDateMap;
  }

  // Handle calendar click (create or destroy absence)
  handleCalendarClick(User user, DateTime dateTime) async {
    final db = await database;

    int user_id = user.id;
    int _startMS = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    int _endMS = _startMS + 86399999;

    var res = await db.rawQuery(
        'SELECT * FROM Absence WHERE user_id = ? AND date BETWEEN ? and ?',
        [user_id.toString(), _startMS.toString(), _endMS.toString()]);

    List<Absence> list =
        res.isNotEmpty ? res.map((c) => Absence.fromMap(c)).toList() : [];

    if (list.length > 0) {
      deleteAbsence(user, dateTime);
    } else {
      Absence absence = Absence(user_id: user_id, date: _startMS);
      upsertAbsence(absence);
    }
  }

  dummy() async {
    final db = await database;
    return {1: true, 2: false};
  }

  checkToday(List<User> allUsers, DateTime dateTime) async {
    final db = await database;

    Map<int, bool> output = {};
    
    
    int _startMS = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    int _endMS = _startMS + 86399999;

    for (var i = 0; i < allUsers.length; i++) {
      int user_id = allUsers[i].id;
      var res = await db.rawQuery(
          'SELECT * FROM Absence WHERE user_id = ? AND date BETWEEN ? and ?',
          [user_id.toString(), _startMS.toString(), _endMS.toString()]);
      if (res.length > 0) {
        output[user_id] = true;
      } else {
        output[user_id] = false;
      }
    }

    return output;
  }
}
