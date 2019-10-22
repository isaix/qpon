import 'package:flutter/material.dart';
import 'package:Qpon/Components/Card.dart';

import 'Home.dart';
import 'Scanner.dart';
import 'Map.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {

  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Colors.deepOrangeAccent[200],
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            CardComponent(),
            CardComponent(),
            CardComponent(),
            CardComponent(),
            CardComponent(),
            CardComponent(),
            CardComponent(),
          ]),
        ));
  }
}
