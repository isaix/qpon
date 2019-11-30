import 'package:Qpon/Components/HorizontalList.dart';
import 'package:Qpon/Components/Slider.dart';
import 'package:flutter/material.dart';
import 'package:Qpon/Components/Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = Firestore.instance;

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  var _slides = [];

  getData() {
    databaseReference
        .collection("settings")
        .document("images")
        .get()
        .then((snapshot) {
      setState(() {
        _slides = snapshot.data["slider"];
      });
    });
  }

  Widget build(BuildContext context) {
    getData();

    return Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            SliderComponent(slides: _slides),
            HorizontalList(
                height: 70,
                title: "Categories",
                items: [1, 2, 3, 4, 5, 6, 7, 8].map((i) {
                  return Column(
                    children: <Widget>[
                      Flexible(
                        child: Image(
                            image: AssetImage('assets/images/icon${i}@3x.png')),
                      )
                    ],
                  );
                }).toList()),
            HorizontalList(height: 100, title: "Nearby Locations", items: []),
            CardComponent()
          ]),
        ));
  }
}
