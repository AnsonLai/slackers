import 'dart:convert';

class User {
  int id;
  String name;

  User({
    this.id,
    this.name,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}