import 'dart:convert';

class User {
  User();

  int id;
  String name;

  static final columns = ["id", "name"];

  Map toMap () {
    Map map = {
      "name": name,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap (Map map) {
    User user = new User();
    user.id = map["id"];
    user.name = map["name"];

    return user;
  }
}