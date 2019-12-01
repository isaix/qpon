import 'package:Qpon/Views/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/Login.dart';
import 'Components/SearchBar.dart';
import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key, this.currentUser, this.currentUserRole})
      : super(key: key);
  final FirebaseUser currentUser;
  final String currentUserRole;

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [
      HomeView(),
      ScannerView(currentUser: this.widget.currentUser),
      MapView(),
      ProfileView(),
    ];

    if (widget.currentUserRole == 'Store') {
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
    } else {
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
  }

  void saveRemainLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remainLoggedIn', false);
  }
}
