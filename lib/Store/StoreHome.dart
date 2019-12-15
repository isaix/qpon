import 'package:Qpon/Views/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'StoreRequestPage.dart';

class StoreHome extends StatefulWidget {
  const StoreHome({Key key, this.currentUserID}) : super(key: key);
  final String currentUserID;

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<StoreHome> {
  final Firestore ref = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String _fcmToken, storeID, storeName = '';

  @override
  initState() {
    super.initState();

    ref
        .collection('users')
        .document(widget.currentUserID)
        .get()
        .then((snapshot) {
      setState(() {
        storeID = snapshot.data['storeID'];
      });

      ref.collection('stores').document(storeID).get().then((snapshot) {
        setState(() {
          storeName = snapshot.data['name'];
        });
      });
    });

    _fcm.onTokenRefresh.listen(sendTokenToServer);
    _fcm.getToken();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        var title = message['notification']['title'];
        if (title == 'Coupon Request') {
          var returnToken = message['data']['returnToken'];
          var userID = message['data']['userID'];
          print("token: " + returnToken);
          //_recievedNotificationAlert(returnToken);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreRequest(
                        userToken: returnToken,
                        userID: userID,
                        storeID: widget.currentUserID,
                      )));
        } else {
          print("awee");
        }
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  storeName,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
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
                padding: EdgeInsets.only(top: 20, bottom: 30),
                child: RaisedButton(
                  onPressed: () {
                    saveRemainLoggedOut();
                    clearUserInformation();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginView()));
                  },
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12, left: 6, right: 6),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }

  void clearUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', null);
    await prefs.setString('id', null);
    await prefs.setString('email', null);
  }

  void sendTokenToServer(String fcmToken) async {
    print("Token: " + fcmToken);

    await ref
        .collection('users')
        .document(widget.currentUserID)
        .updateData({'token': fcmToken});
  }

  /*
  void _recievedNotificationAlert(String from) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Success!"),
          content: new Text("You got a notification from device with ID: " + from),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Return"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => StoreRequest(userToken: from,)));
              },
            ),
          ],
        );
      },
    );
  }
  */
}
