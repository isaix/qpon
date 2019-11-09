import 'package:flutter/material.dart';

import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';
import 'Login/LoginPage.dart';

void main() => runApp(Qpon());

class Qpon extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return QponState();
  }
}

class QponState extends State<Qpon>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "QPON",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
    ),
    home: new LoginPage(),
    );
  }
}