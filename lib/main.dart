import 'package:flutter/material.dart';

import './Home.dart';
import './Scanner.dart';
import './Map.dart';

void main() => runApp(MyApp()); 

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{

  int _selectedPage = 0; 
  final _pageOptions = [
    HomePage(),
    ScannerPage(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "QPON",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('QPON'),),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index){
            setState(() {
              _selectedPage = index;
            });
          },
          items:[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.device_unknown),
              title: Text('Scanner')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Map')
            ),
          ]

        ),
      ),
    );
  }
}