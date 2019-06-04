import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "slackersDB.db");

    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    """);
    await db.execute("""
      CREATE TABLE absence (
        id INTEGER PRIMARY KEY,
        date INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user (id)
          ON DELETE CASCADE ON UPDATE CASCADE
      )
    """);
  }

}