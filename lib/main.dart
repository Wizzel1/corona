import 'dart:convert';

import 'package:coronaapp/screens/history.dart';
import 'package:coronaapp/screens/info_screen.dart';
import 'package:coronaapp/models/model.dart';
import 'package:coronaapp/navigation.dart';
import 'package:coronaapp/widgets/chart.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coronaapp/widgets/counter.dart';
import 'widgets/my_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/jsonparse.dart';
import 'package:coronaapp/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: kBackgroundColor,
      title: 'Covid 19',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: GoogleFonts.iBMPlexSans().fontFamily,
        textTheme: TextTheme(body1: TextStyle(color: kBodyTextColor)),
      ),
      home: Home(),
    );
  }
}
