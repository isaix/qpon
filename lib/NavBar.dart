import 'package:Qpon/Views/Profile.dart';
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
      return StoreHome(currentUser: widget.currentUser);
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
