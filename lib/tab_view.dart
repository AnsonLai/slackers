import 'package:flutter/material.dart';

class _TabView {
  const _TabView({this.title, this.widget});
  final String title;
  final Widget widget;
}

Widget test = Text("hello");

List<_TabView> _allTabViews = <_TabView>[
  _TabView(title: 'HOME', widget: test),
];

class _Page {
  const _Page({this.icon, this.text});
  final IconData icon;
  final String text;
}

const List<_Page> _allPages = <_Page>[
  _Page(icon: Icons.playlist_add, text: 'TRIUMPH'),
  _Page(icon: Icons.playlist_add, text: 'NOTE'),
  _Page(icon: Icons.check_circle, text: 'SUCCESS'),
  _Page(icon: Icons.question_answer, text: 'OVERSTATE'),
  _Page(icon: Icons.sentiment_very_satisfied, text: 'SATISFACTION'),
  _Page(icon: Icons.camera, text: 'APERTURE'),
  _Page(icon: Icons.assignment_late, text: 'WE MUST'),
  _Page(icon: Icons.assignment_turned_in, text: 'WE CAN'),
  _Page(icon: Icons.group, text: 'ALL'),
  _Page(icon: Icons.block, text: 'EXCEPT'),
];

class ScrollableTabsDemo extends StatefulWidget {
  @override
  ScrollableTabsDemoState createState() => ScrollableTabsDemoState();
}

class ScrollableTabsDemoState extends State<ScrollableTabsDemo>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  bool _customIndicator = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Decoration getIndicator() {
    if (!_customIndicator) return const UnderlineTabIndicator();
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slackers'),
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          indicator: getIndicator(),
          tabs: _allPages.map<Tab>((_Page page) {
            return Tab(text: page.text);
            return null;
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _allPages.map<Widget>((_Page page) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Container(
              key: ObjectKey(page.icon),
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Center(
                  child: Icon(
                    page.icon,
                    color: iconColor,
                    size: 128.0,
                    semanticLabel: 'Placeholder for ${page.text} tab',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
