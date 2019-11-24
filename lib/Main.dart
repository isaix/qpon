import 'dart:math';

import 'package:Qpon/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/LoginPage.dart';

void main(){
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(Qpon());
}

class Qpon extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return QponState();
  }
}

class QponState extends State<Qpon>{
  bool _remainLoggedIn = false;

  @override
  Widget build(BuildContext context){
    getRemainLoggedIn();
    return MaterialApp(
      title: "QPON",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
    ),
    home: _remainLoggedIn? new NavBar() : new LoginPage(),
    );
  }

  void getRemainLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.get('remainLoggedIn');

    if(loggedIn != null){
      setState(() {
      _remainLoggedIn = loggedIn;
    });
    }
  }
}