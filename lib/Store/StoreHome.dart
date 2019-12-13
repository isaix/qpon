import 'package:Qpon/API/MessagingWidget.dart';
import 'package:Qpon/Model/FirebaseMessage.dart';
import 'package:Qpon/Views/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class StoreHome extends StatefulWidget {
  const StoreHome({Key key, this.currentUserID}) : super(key: key);
  final String currentUserID;

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<StoreHome> {
  final Firestore ref = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseMessage _currentMessage =
      FirebaseMessage(title: "Bob's Pizza", body: "Starting Value");
  String _fcmToken;

  @override
  initState() {
    super.initState();

    _fcm.onTokenRefresh.listen(sendTokenToServer);
    _fcm.getToken();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QPON'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                _currentMessage.title + _currentMessage.body,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          Center(
            child: QrImage(
              data: widget.currentUserID,
              version: QrVersions.auto,
              size: 250,
              gapless: false,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: RaisedButton(
                child: Text('Log out'),
                onPressed: () {
                  saveRemainLoggedOut();
                  clearUserInformation();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginView()));
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: RaisedButton(
                  child: Text('send notification'),
                  onPressed: () {
                    sendNotification();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }

  void clearUserInformation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', null);
    await prefs.setString('id', null);
  }

  void sendTokenToServer(String fcmToken) async{
    print("Token: " + fcmToken);
    
    await ref.collection('users').document(widget.currentUserID).updateData({'token': fcmToken});
  }

  Future sendNotification() async {
    final response = await Messaging.sendTo(
      title: "HEJ ISAAC!",
      body: "test",
      fcmToken:
          "cErNZEfSg1Q:APA91bFG4uWBqoLGHpO0PRUvNhnnAowcMBbzCLS1FqA9SJAdAYYC_3ouvruYu9uIc-ZnjdgfxYxR7tXV0WUTwcmAmor-WGgVUbBiVSgi8ai7KhtsAJiSilZ12QuA6Z2Os2mSwlEwSJHW",
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
}
