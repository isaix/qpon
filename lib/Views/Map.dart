import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 30),
            child: Text(
              'This widget will, once implemented, depict the location of stores on the map, in which it is possible to recieve coupons.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
