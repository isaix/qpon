import 'package:Qpon/Views/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key, this.currentUserID, this.currentUserEmail}) : super(key: key);
  final String currentUserID, currentUserEmail;

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _selectedPage = 0;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Firestore ref = Firestore.instance;

  @override
  initState() {
    super.initState();

    _fcm.onTokenRefresh.listen(sendTokenToServer);
    _fcm.getToken();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        var title = message['notification']['title'];
        if (title == 'Coupon Response') {
          var couponCount = message['data']['couponCount'];
          print("coupons: " + couponCount);

          Navigator.of(context, rootNavigator: false).pop();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Success!"),
                content: new Text(
                    "You recieved " + couponCount.toString() + " coupons."),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
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
    final _pageOptions = [
      HomeView(),
      ScannerView(currentUserID: this.widget.currentUserID,),
      MapView(),
      ProfileView(currentUserEmail: this.widget.currentUserEmail,),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('QPON'),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
          //backgroundColor: Colors.redAccent,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey[500],
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_to_action),
              title: Text('Coupons'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Map'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            )
          ]),
      );
  }

  void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }

  void sendTokenToServer(String fcmToken) async {
    print("Token: " + fcmToken);

    await ref
        .collection('users')
        .document(widget.currentUserID)
        .updateData({'token': fcmToken});
  }
}
