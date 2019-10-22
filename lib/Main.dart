import 'package:flutter/material.dart';

import 'Views/Home.dart';
import 'Views/Scanner.dart';
import 'Views/Map.dart';

void main() => runApp(Qpon());

class Qpon extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return QponState();
  }
}

class QponState extends State<Qpon>{

  int _selectedPage = 0; 
  final _pageOptions = [
    HomeView(),
    ScannerView(),
    MapView(),
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
              icon: Icon(Icons.camera_alt),
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