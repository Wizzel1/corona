import 'package:coronaapp/constants.dart';
import 'package:coronaapp/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MyHeader(
            image: 'assets/icons/coronadr.svg',
            textTop: 'Infection',
            textBottom: 'History.',
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
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
                        child: ListTile(
                          leading: Text('$index'),
                          title: Text('One-line with both widgets'),
                          trailing: Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  })),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
