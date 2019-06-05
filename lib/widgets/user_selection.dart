import 'package:flutter/material.dart';

import 'package:Slackers/tab_view.dart';

import 'package:Slackers/models/database.dart';
import 'package:Slackers/models/user.dart';
import 'package:Slackers/models/absence.dart';

Widget buildUserSelectionWidget(Function dbChanged) {
  return FutureBuilder(
    future: DatabaseClient.db.getAllUsers(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data != null) {
          List<User> _allUsers = snapshot.data;
          return Scaffold(
            body: Center(
              child: buildUserList(_allUsers),
            ),
            floatingActionButton: buildFloatingButton(context, dbChanged),
          );
        }
      }
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Please add a user.',
              ),
            ],
          ),
        ),
        floatingActionButton: buildFloatingButton(context, dbChanged),
      );
      ;
    },
  );
}

Widget buildUserList(List<User> allUsers) {
  return ListView.builder(
    itemCount: allUsers.length,
    itemBuilder: (BuildContext context, int index) {
      return RaisedButton(
          onPressed: () {
            // int date = DateTime.now().millisecondsSinceEpoch;
            int date = DateTime.utc(2019, 5, 28).millisecondsSinceEpoch;
            int user_id = allUsers[index].id;
            Absence absence = Absence(date: date, user_id: user_id);
            DatabaseClient.db.upsertAbsence(absence);
            print(absence.date);
            final snackBar = SnackBar(content: Text('Noted!'));
            Scaffold.of(context).showSnackBar(snackBar);
          },
          child: Text(allUsers[index].name));
    },
  );
}

Widget buildFloatingButton(BuildContext context, Function dbChanged) {
  String _tempName;
  return FloatingActionButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Add a new user:"),
                content: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (text) {
                          _tempName = text;
                        },
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        if (_tempName != null) {
                          User user = User(name: _tempName);
                          DatabaseClient.db.upsertUser(user);
                          dbChanged();
                        }
                        ;
                        Navigator.of(context).pop();
                      },
                      child: Text('Submit')),
                ],
              ));
    },
    tooltip: 'Add User',
    child: Icon(Icons.add),
  );
}
