import 'dart:convert';

import 'package:coronaapp/screens/history.dart';
import 'package:coronaapp/screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [Home(), History()];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutExpo,
          child: _children[_currentIndex],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CurvedNavigationBar(
            height: 50,
            backgroundColor: Colors.transparent,
            color: Colors.blue[900],
            items: <Widget>[
              Icon(Icons.insert_chart, size: 30, color: kBackgroundColor),
              Icon(Icons.list, size: 30, color: kBackgroundColor),
//              Icon(Icons.fiber_new, size: 30, color: kBackgroundColor),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
