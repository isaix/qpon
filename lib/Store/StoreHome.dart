import 'package:Qpon/Views/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StoreHome extends StatefulWidget {
  const StoreHome({Key key, this.currentUser}) : super(key: key);
  final FirebaseUser currentUser; 
  //widget.currentUser.uid

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<StoreHome> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QPON'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  'Bob\'s Pizza',
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
          ],
        ),
      );
  }

   void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }
}
