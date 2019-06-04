import 'dart:convert';

class Absence {
  int id;
  int date;
  int user_id;

  Absence({
    this.id,
    this.date,
    this.user_id,
  });

  factory Absence.fromMap(Map<String, dynamic> json) => new Absence(
    id: json["id"],
    date: json["date"],
    user_id: json["user_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date,
    "user_id": user_id,
  };
}

Absence absenceFromJson(String str) {
  final jsonData = json.decode(str);
  return Absence.fromMap(jsonData);
}

String absenceToJson(Absence data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}