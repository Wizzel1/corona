import 'package:coronaapp/constants.dart';
import 'package:coronaapp/models/model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LineChartSample1 extends StatefulWidget {
  final List<Day> dayList;
  final formatter = new NumberFormat('#,###,###');
  LineChartSample1(this.dayList);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  double _lineWidth = 4;
  int _descaleValue = 1000000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: Duration(milliseconds: 250),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> barSpots) {
            String date = widget.dayList[barSpots[0].spotIndex].date;
            List<String> temp = date.replaceAll('-', ' ').split(' ');
            temp[1].length != 2 ? temp[1] = '0${temp[1]}' : 0;
            temp[2].length != 2 ? temp[2] = '0${temp[2]}' : 0;
            String usedDate =
                DateFormat('d MMMM').format(DateTime.parse(temp[0] + temp[1] + temp[2]));

            String confirmed =
                widget.formatter.format(widget.dayList[barSpots[0].spotIndex].confirmed).toString();
            String recovered =
                widget.formatter.format(widget.dayList[barSpots[2].spotIndex].recovered).toString();
            String deaths =
                widget.formatter.format(widget.dayList[barSpots[1].spotIndex].deaths).toString();
            LineTooltipItem dateItem = LineTooltipItem(
                usedDate,
                kTitleTextstyle.copyWith(
                    color: Colors.grey,
                    fontSize: 15,
                    fontFamily: GoogleFonts.iBMPlexSans().fontFamily));
            LineTooltipItem confirmedItem = LineTooltipItem(
                confirmed,
                kTitleTextstyle.copyWith(
                    color: kInfectedColor,
                    fontSize: 15,
                    fontFamily: GoogleFonts.iBMPlexMono().fontFamily,
                    fontWeight: FontWeight.w600));
            LineTooltipItem recoveredItem = LineTooltipItem(
                recovered,
                kTitleTextstyle.copyWith(
                    color: kRecovercolor,
                    fontSize: 15,
                    fontFamily: GoogleFonts.iBMPlexMono().fontFamily,
                    fontWeight: FontWeight.w600));
            LineTooltipItem deathsItem = LineTooltipItem(
                deaths,
                kTitleTextstyle.copyWith(
                    color: kDeathColor,
                    fontSize: 15,
                    fontFamily: GoogleFonts.iBMPlexMono().fontFamily,
                    fontWeight: FontWeight.w600));
            return [dateItem, confirmedItem, recoveredItem, deathsItem];
          },
          tooltipBgColor: kBackgroundColor,
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        horizontalInterval: widget.dayList.last.confirmed < 500000 ? 1.0 : 5.0,
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: GoogleFonts.iBMPlexSans().fontFamily),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 11:
                return 'February';
              case 40:
                return 'March';
              case 72:
                return 'April';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Color(0xff75729e),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: GoogleFonts.iBMPlexSans().fontFamily),
          getTitles: (value) {
            switch (value) {
              case 0.1:
                return '100k';
              case 0.5:
                return '500k';
              case 1.0:
                return '1M';
              case 1.5:
                return '1.5M';
              case 2.0:
                return '2M';
              case 2.5:
                return '2.5M';
              default:
                return '';
            }
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: widget.dayList.length.toDouble(),
      maxY: widget.dayList.last.confirmed / _descaleValue,
      minY: 0,
      lineBarsData: _createData(widget.dayList),
    );
  }

  List<LineChartBarData> _createData(List<Day> raw) {
    LineChartBarData confirmedData = LineChartBarData(
      spots: List.from(raw.map((e) {
        double index = raw.indexOf(e).toDouble();
        return FlSpot(index, e.confirmed / _descaleValue);
      })),
      isCurved: true,
      colors: [
        kInfectedColor,
      ],
      barWidth: _lineWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    LineChartBarData recoveredData = LineChartBarData(
      spots: List.from(raw.map((e) {
        double index = raw.indexOf(e).toDouble();
        return FlSpot(index, e.recovered / _descaleValue);
      })),
      isCurved: true,
      colors: [
        kRecovercolor,
      ],
      barWidth: _lineWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    LineChartBarData deathsData = LineChartBarData(
      spots: List.from(raw.map((e) {
        double index = raw.indexOf(e).toDouble();
        return FlSpot(index, e.deaths / _descaleValue);
      })),
      isCurved: true,
      colors: [
        kDeathColor,
      ],
      barWidth: _lineWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    LineChartBarData dateData = LineChartBarData(
      spots: List.from(raw.map((e) {
        double index = raw.indexOf(e).toDouble();
        return FlSpot(index, 0);
      })),
      isCurved: true,
      colors: [
        Colors.transparent,
      ],
      barWidth: _lineWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [confirmedData, recoveredData, deathsData, dateData];
  }
}
