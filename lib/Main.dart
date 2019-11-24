import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';
import 'Views/LoginPage.dart';
import 'NavBar.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(Qpon());
}

class Qpon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QponState();
  }
}

class QponState extends State<Qpon> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QPON",
      theme: ThemeData(
        brightness: Brightness.light,
      ),
//      darkTheme: ThemeData(
//          brightness: Brightness.dark,
//      ),
//    home: new LoginView(),
      home: new NavBar(),
    );
  }
}
