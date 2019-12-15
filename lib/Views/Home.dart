import 'package:Qpon/Components/HorizontalList.dart';
import 'package:Qpon/Components/Map.dart';
import 'package:Qpon/Components/Slider.dart';
import 'package:flutter/material.dart';
import 'package:Qpon/Components/Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final databaseReference = Firestore.instance;

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  List _slides = [];
  List<Widget> _nearbyLocations = <Widget>[];

  @override
  initState() {
    super.initState();
    _getLocations();
    _getCurrentLocation();
  }

  Widget build(BuildContext context) {
    getData();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
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
                                image: AssetImage(
                                    'assets/images/icon${i}@3x.png')),
                          )
                        ],
                      );
                    }).toList()),
                HorizontalList(
                    height: 150,
                    title: "Nearby Locations",
                    items: _nearbyLocations),
              ]),
            ),
          ),
        );
      },
    );
  }

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

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
//      _getLocations(_currentPosition);
    }).catchError((e) {
      print(e);
    });
  }

  _getLocations() {
    databaseReference.collection("stores").getDocuments().then((snapshot) {
      setState(() {
        _nearbyLocations = snapshot.documents
            .map<Widget>((document) => CardComponent(
                title: document.data['name'],
                address:
                    '${document.data['address']['street']} ${document.data['address']['number']}',
                distance: 500,
                stamps: 5))
            .toList();
      });
    });
  }

  _getDistance(LatLng start, LatLng destination) {
    Geolocator()
        .placemarkFromAddress("Nørre Farimagsgade 57, 1364 København");

  }
}
