import 'dart:convert';
import 'package:coronaapp/widgets/FutureLineChart.dart';
import 'package:coronaapp/models/model.dart';
import 'package:coronaapp/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coronaapp/widgets/counter.dart';
import '../widgets/my_header.dart';
import '../services/jsonparse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedCountry;
  String currentText = "";
  Future<List<Day>> dayList;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    dayList = JsonService().fetchData(_selectedCountry);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: 'assets/icons/drcorona.svg',
              textTop: 'Covid 19',
              textBottom: 'Tracker',
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset('assets/icons/maps-and-flags.svg'),
                  const SizedBox(width: 20),
                  FutureBuilder(
                    future: JsonService().fetchCountrys(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Padding(
                            padding: EdgeInsets.fromLTRB(10, 12, 0, 7),
                            child: Text(
                              'Loading...',
                              style: kSubTextStyle,
                            ),
                          );
                        default:
                          return Expanded(
                            child: searchTextField = AutoCompleteTextField<String>(
                                key: key,
                                style: kSubTextStyle,
                                controller: controller,
                                suggestions: snapshot.data,
                                clearOnSubmit: false,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 8),
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    filled: false,
                                    hintText: 'Search Country',
                                    hintStyle: kSubTextStyle),
                                itemSubmitted: (item) {
                                  setState(() {
                                    searchTextField.textField.controller.text = item;
                                    _selectedCountry = item;
                                  });
                                },
                                itemBuilder: (context, item) {
                                  return Text(
                                    item,
                                    style: kSubTextStyle.copyWith(fontSize: 20),
                                  );
                                },
                                itemSorter: (a, b) {
                                  return a.toLowerCase().compareTo(b.toLowerCase());
                                },
                                itemFilter: (item, query) {
                                  return item.toLowerCase().startsWith(query.toLowerCase());
                                }),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Case Update \n',
                        style: kTitleTextstyle,
                      ),
                      _buildInfoButton(
                        context,
                        title: 'Case Update',
                        content: SelectableLinkify(
                          onOpen: _onOpen,
                          text:
                              'These are the tracked cases to this day. The Data gets updated 3x per Day.\n\n'
                              'Provided by Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE): https://systems.jhu.edu/\n\n'
                              'Find out about the Datasources here : https://github.com/CSSEGISandData/COVID-19',
                          style: kSubTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                      future: dayList,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container();
                          default:
                            if (snapshot.hasError) {
                              return Text(snapshot.error);
                            } else {
                              List<Day> data = snapshot.data;
                              Day latestDay = data.last;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: CounterWidget(
                                      color: kInfectedColor,
                                      number: latestDay.confirmed,
                                      title: 'Infected',
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: CounterWidget(
                                      color: kDeathColor,
                                      number: latestDay.deaths,
                                      title: 'Deaths',
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: CounterWidget(
                                      color: kRecovercolor,
                                      number: latestDay.recovered,
                                      title: 'Recovered',
                                    ),
                                  ),
                                ],
                              );
                            }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Spread over Time',
                        style: kTitleTextstyle,
                      ),
                      _buildInfoButton(context,
                          title: 'Spread over time',
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SelectableLinkify(
                                onOpen: _onOpen,
                                text:
                                    'This Chart shows the cases from January 22 to this Date .\n\n'
                                    'Touch anywhere on the Chart to get detailed Information like this :\n',
                                style: kSubTextStyle,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 30,
                                      color: kShadowColor,
                                    ),
                                  ],
                                ),
                                child: Image(
                                  image: AssetImage('assets/images/screenshot.png'),
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.none,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                  FutureLineChart(future: dayList),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  GestureDetector _buildInfoButton(BuildContext context, {String title, Widget content}) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AlertDialog(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  title,
                  style: kTitleTextstyle,
                ),
                content: content,
                backgroundColor: kBackgroundColor,
              )),
      child: Text(
        'Info',
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600)
            .copyWith(fontFamily: GoogleFonts.iBMPlexSans().fontFamily),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
