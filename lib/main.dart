import 'package:flutter/material.dart';

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
    Text('Home', style: TextStyle(fontSize: 36.0),),
    Text('Scanner', style: TextStyle(fontSize: 36.0),),
    Text('Map', style: TextStyle(fontSize: 36.0),),
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