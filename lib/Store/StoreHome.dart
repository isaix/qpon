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
import 'package:swipe_button/swipe_button.dart';

class StoreHome extends StatefulWidget {
  const StoreHome({Key key, this.currentUser}) : super(key: key);
  final FirebaseUser currentUser;

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<StoreHome> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseMessage _currentMessage =
      FirebaseMessage(title: "Bob's Pizza", body: "Starting Value");

  @override
  initState() {
    super.initState();
    _fcm.onTokenRefresh.listen(sendTokenToServer);
    _fcm.getToken();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          _currentMessage = FirebaseMessage(
              title: notification['title'], body: notification['body']);
        });
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
          QrImage(
            data: widget.currentUser.uid,
            version: QrVersions.auto,
            size: 250,
            gapless: false,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: RaisedButton(
                child: Text('Log out'),
                onPressed: () {
                  saveRemainLoggedOut();
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
          SwipeButton(
            thumb: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    widthFactor: 0.90,
                    child: Icon(
                      Icons.chevron_right,
                      size: 60.0,
                      color: Colors.white,
                    )),
              ],
            ),
            content: Center(
              child: Text(
                'hej',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onChanged: (result) {},
          ),
        ],
      ),
    );
  }

  void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: ' + fcmToken);
  }

  Future sendNotification() async {
    final response = await Messaging.sendTo(
      title: "HEJ ISAAC",
      body: "EYYYY",
      fcmToken:
          "eaJFbxrfPbA:APA91bHxhVIWGPgP16IyP1jXTnZj-Ir2PhLDDP8F0QdMn_gyWtczjIjMUfGbOwKqtt2YotztAFew8FaetCu2emGyszS5ARQIwAzbOxTkl9cAStg0X-U6eN9QbvZWd4n0vnptY9kGaZJS",
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
}
