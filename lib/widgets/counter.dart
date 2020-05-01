import 'package:flutter/material.dart';
import 'package:coronaapp/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CounterWidget extends StatefulWidget {
  final int number;
  final Color color;
  final String title;
  final Widget widget;

  const CounterWidget({
    Key key,
    this.number,
    this.color,
    this.title,
    this.widget,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> with TickerProviderStateMixin {
  final formatter = new NumberFormat('#,###,###');
  AnimationController _animationController;
  AnimationController _numberController;
  Animation _insetAnimation;
  Animation _opacityAnimation;
  Animation _numberAnimation;

  @override
  void initState() {
    int duration = (2 + widget.number ~/ 50000).clamp(2, 4);
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _numberController = AnimationController(vsync: this, duration: Duration(seconds: duration));
    _animationController.repeat(reverse: true);
    _numberController.forward();
    _insetAnimation = Tween(begin: 12.0, end: 0.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOutQuint));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOutQuint));
    _numberAnimation = IntTween(begin: 0, end: widget.number)
        .animate(CurvedAnimation(parent: _numberController, curve: Curves.easeOutExpo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return Container(
              padding: EdgeInsets.all(_insetAnimation.value),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(.26),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                      color: widget.color.withOpacity(_opacityAnimation.value), width: 2),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: _numberController,
          builder: (BuildContext context, Widget child) {
            return Text(
              formatter.format(_numberAnimation.value).toString(),
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 22,
                  color: widget.color,
                  fontFamily: GoogleFonts.iBMPlexMono().fontFamily,
                  fontWeight: FontWeight.w600),
            );
          },
        ),
        Text(
          widget.title,
          style: kSubTextStyle,
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
