import 'package:flutter/material.dart';

import 'package:Slackers/models/database.dart';
import 'package:Slackers/models/user.dart';

Future<Widget> buildUserPageWidget(User user) async {
  List<User> allUsers = await DatabaseClient.db.getAllUsers();
  return Text('asdfasdfas');
}