import 'package:Qpon/Views/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/LoginPage.dart';
import 'Components/SearchBar.dart';
import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Store/StoreHome.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key, this.currentUserID})
      : super(key: key);
  final String currentUserID;

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
      ScannerView(currentUserID: this.widget.currentUserID),
      MapView(),
      ProfileView(),
    ];

    return Scaffold(
      appBar: SearchBar(
        height: 60,
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
              icon: Icon(Icons.camera_alt),
              title: Text('Scanner'),
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

  void sendTokenToServer(String fcmToken) async{
    print("Token: " + fcmToken);
    
    await ref.collection('users').document(widget.currentUserID).updateData({'token': fcmToken});
  }
}
