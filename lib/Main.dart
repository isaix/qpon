import 'dart:math';
import 'package:Qpon/NavBar.dart';
import 'package:Qpon/Store/StoreHome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/Login.dart';
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

class QponState extends State<Qpon>{
  bool _remainLoggedIn = false;
  String _userRole, _userID;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context){
    getRemainLoggedIn();
    getUserInformation();
    return MaterialApp(
      title: "QPON",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
    ),
    home: _remainLoggedIn? startingViewBasedOnRole() : new LoginView(),
    debugShowCheckedModeBanner: false,
    );
  }

  void checkCurrentToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('fcmToken');

    if(token == null){
      _fcm.onTokenRefresh.listen(saveToken);
      _fcm.getToken();
    }
  }

  Widget startingViewBasedOnRole(){
    if(_userRole == "User"){
      return new NavBar(currentUserID: _userID,);
    }
    else if(_userRole == "Store"){
      return new StoreHome(currentUserID: _userID);
    }
    else{
      return new LoginView();
    }
  }

  void saveToken(String fcmToken) async {
    print('Token: ' + fcmToken);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', fcmToken);
  }

  void getUserInformation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role');
    String id = prefs.getString('id');

    setState(() {
      _userRole = role;
      _userID = id;
    });
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

