import 'package:flutter/material.dart';


import 'Home.dart';
import 'Scanner.dart';
import 'Map.dart';


class HomeView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(25.0),
      child: Column(
        children: <Widget>[ScannerView(), ScannerView(), MapView()],
      )
     // Text('Home', style: TextStyle(fontSize: 36.0),),
    );
  }
}