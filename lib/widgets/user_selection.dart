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
          if (_allUsers.length > 0) {
            return Scaffold(
              body: Center(
                child: buildUserList(_allUsers, dbChanged),
              ),
              floatingActionButton: buildFloatingButton(context, dbChanged),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Please add a new user to begin.',
                    ),
                  ],
                ),
              ),
              floatingActionButton: buildFloatingButton(context, dbChanged),
            );
          }
        }
      }
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Loading...',
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

Widget buildUserList(List<User> allUsers, Function dbChanged) {
  return FutureBuilder(
      future: DatabaseClient.db.checkToday(allUsers, DateTime.now()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Map<int, bool> _todayUsers = snapshot.data;
        return ListView.builder(
            itemCount: allUsers.length,
            itemBuilder: (BuildContext context, int index) {
              if (_todayUsers != null && _todayUsers.containsKey(allUsers[index].id)) {
                if (!_todayUsers[allUsers[index].id]) {
                  return RaisedButton(
                      onPressed: () {
                        int date = DateTime.now().millisecondsSinceEpoch;
                        int user_id = allUsers[index].id;
                        Absence absence = Absence(date: date, user_id: user_id);
                        DatabaseClient.db.upsertAbsence(absence);
                        final snackBar = SnackBar(content: Text('Noted!'));
                        Scaffold.of(context).showSnackBar(snackBar);
                        dbChanged();
                      },
                      color: Colors.green[300],
                      child: Text(allUsers[index].name));
                } else {
                  return RaisedButton(
                      onPressed: null,
                      child: Text(allUsers[index].name));
                }
                return null;
              }
            });
      });
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
