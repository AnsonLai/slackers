import 'package:flutter/material.dart';

import 'package:Slackers/models/database.dart';
import 'package:Slackers/models/user.dart';
import 'package:Slackers/widgets/user_selection.dart';
import 'package:Slackers/widgets/user_page.dart';



class _TabView {
  const _TabView({this.title, this.widget});
  final String title;
  final Widget widget;
}

List<_TabView> _allTabViews = <_TabView>[];

class ScrollableTabs extends StatefulWidget {
  @override
  ScrollableTabsState createState() => ScrollableTabsState();
}

class ScrollableTabsState extends State<ScrollableTabs>
    with TickerProviderStateMixin {
  TabController _controller;
  List<User> _allUsers;

  void changeTabView(allUsers) {
    _allTabViews = <_TabView>[];
    _allTabViews.add(_TabView(
        title: 'HOME', widget: buildUserSelectionWidget(this.dbChanged)));
    for (var i = 0; i < allUsers.length; i++) {
      _allTabViews.add(_TabView(title: allUsers[i].name, widget: buildUserPageWidget(allUsers[i], this.dbChanged)));
    }
  }

  void dbChanged() {
    DatabaseClient.db.getAllUsers().then((allUsers) {
      setState(() {
        _allUsers = allUsers;
        changeTabView(_allUsers);
        _controller.dispose();
        _controller = TabController(vsync: this, length: _allTabViews.length);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _allTabViews.add(_TabView(
        title: 'HOME', widget: buildUserSelectionWidget(this.dbChanged)));
    dbChanged();
    _controller = TabController(vsync: this, length: _allTabViews.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Decoration getIndicator() {
    return ShapeDecoration(
      shape: const StadiumBorder(
            side: BorderSide(
              color: Colors.white24,
              width: 2.0,
            ),
          ) +
          const StadiumBorder(
            side: BorderSide(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_allUsers == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Slackers'),
          bottom: TabBar(
            controller: _controller,
            isScrollable: true,
            indicator: getIndicator(),
            tabs: _allTabViews.map<Tab>((_TabView tabview) {
              return Tab(text: tabview.title);
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: _allTabViews.map<Widget>((_TabView tabview) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Center(
                    child: tabview.widget,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Slackers DONE LOADING'),
          bottom: TabBar(
            controller: _controller,
            isScrollable: true,
            indicator: getIndicator(),
            tabs: _allTabViews.map<Tab>((_TabView tabview) {
              return Tab(text: tabview.title);
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: _allTabViews.map<Widget>((_TabView tabview) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Center(
                    child: tabview.widget,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }
}
