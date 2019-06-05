import 'package:flutter/material.dart';

import 'package:Slackers/tab_view.dart';

import 'package:Slackers/models/database.dart';
import 'package:Slackers/models/user.dart';

Widget buildUserSelectionWidget() {
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
            floatingActionButton: buildFloatingButton(context),
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
        floatingActionButton: buildFloatingButton(context),
      );
      ;
    },
  );
}

Widget buildUserList(List<User> allUsers) {
  return  ListView.builder(
      itemCount: allUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(allUsers[index].name);
      },

  );
}

Widget buildFloatingButton(BuildContext context) {
  String _tempName;
  return FloatingActionButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Add a new user:"),
                content: Column(
                  children: [
                    TextField(
                      onChanged: (text) {
                        _tempName = text;
                      },
                    ),
                    RaisedButton(
                        onPressed: () {
                          if (_tempName != null) {
                            User user = User(name: _tempName);
                            DatabaseClient.db.upsertUser(user);
                            setState();
                          }
                          ;
                          Navigator.of(context).pop();
                        },
                        child: Text('Add!')),
                  ],
                ),
              ));
    },
    tooltip: 'Increment',
    child: Icon(Icons.add),
  );
}
