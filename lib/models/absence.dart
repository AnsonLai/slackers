import 'dart:convert';
import 'user.dart';

class Absence {
  Absence();

  int id;
  int date;
  int user_id;
  // User user;

  static final columns = ["id", "date", "user_id"];

  Map toMap () {
    Map map = {
      "date": date,
      "user_id": user_id,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap (Map map) {
    Absence absence = new Absence();
    absence.id = map["id"];
    absence.date = map["date"];
    absence.user_id = map["user_id"];

    return absence;
  }
}