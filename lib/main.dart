import 'package:flutter/material.dart';

import 'tab_view.dart';

void main() => runApp(SlackersApp());

class SlackersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slackers',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ScrollableTabs(),
    );
  }
}
