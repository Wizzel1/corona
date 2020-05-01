import 'package:coronaapp/constants.dart';
import 'package:coronaapp/models/model.dart';
import 'package:coronaapp/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FutureLineChart extends StatelessWidget {
  const FutureLineChart({
    Key key,
    @required this.future,
  }) : super(key: key);

  final Future<List<Day>> future;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: Offset(0, 10), blurRadius: 30, color: kShadowColor),
        ],
      ),
      child: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SpinKitThreeBounce(
                color: Colors.blueAccent,
                size: 50.0,
              );
            default:
              if (snapshot.hasError) {
                return Text(snapshot.error);
              } else {
                return LineChartSample1(snapshot.data);
              }
          }
        },
      ),
    );
  }
}
