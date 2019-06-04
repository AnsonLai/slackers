import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'user.dart';
import 'absence.dart';

class DatabaseClient {
  DatabaseClient._();
  static final DatabaseClient db = DatabaseClient._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await create();
    return _database;
  }

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "slackersDB.db");

    _database = await openDatabase(dbPath, version: 1, onCreate: this._create);
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
    db.delete("User", where: "id = ?", whereArgs: [user.id]);
  }
}
