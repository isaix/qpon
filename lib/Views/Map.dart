import 'package:Qpon/Components/Map.dart';
import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {


  @override
  Widget build(BuildContext context) {
    return Container(
//      child: Column(
//        children: <Widget>[
//          Container(
            height: MediaQuery.of(context).size.height * .75,
            width: MediaQuery.of(context).size.width * .95,
            child: MapSample(),
//          )
//        ],
//        mainAxisAlignment: MainAxisAlignment.center,
      );
//    );
  }
}
