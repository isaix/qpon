import 'package:Qpon/Components/HorizontalList.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Qpon/Components/Card.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {

  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            CarouselSlider(
//              height: MediaQuery.of(context).size.height * 0.2,
              aspectRatio: 21/9,
              viewportFraction: 0.92,
              enlargeCenterPage: true,

              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'text $i', style: TextStyle(fontSize: 16.0),)
                    );
                  },
                );
              }).toList(),
            ),
            HorizontalList(),
            CardComponent(),
            CardComponent(),
            CardComponent(),
            CardComponent(),
          ]),
        ));
  }
}
