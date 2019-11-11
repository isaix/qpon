import 'package:Qpon/Views/Profile.dart';
import 'package:flutter/material.dart';
import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';

class NavBar extends StatefulWidget{
  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar>{
  int _selectedPage = 0; 
  final _pageOptions = [
    HomeView(),
    ScannerView(),
    MapView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('QPON'),),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          //backgroundColor: Colors.redAccent,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey[500],
          currentIndex: _selectedPage,
          onTap: (int index){
            setState(() {
              _selectedPage = index;
            });
          },
          items:[
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
          ]

        ),
      );
  }
}