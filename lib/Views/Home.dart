import 'package:Qpon/Components/HorizontalList.dart';
import 'package:Qpon/Components/Map.dart';
import 'package:Qpon/Components/Slider.dart';
import 'package:flutter/material.dart';
import 'package:Qpon/Components/Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

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
  String _currentAddress;

  var _slides = [];

  Widget build(BuildContext context) {
    getData();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Container(
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
                    items: [CardComponent(), CardComponent()]),
                Column(children: [
                  _currentPosition == null
                      ? CircularProgressIndicator()
                      : Text(
                          "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
                  _currentAddress == null
                      ? CircularProgressIndicator()
                      : Text(_currentAddress),
                ]),
                RaisedButton(
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  color: Colors.blue,
                  child: Text(
                    "Get Location",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

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
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}, ${place.thoroughfare}, ${place.subThoroughfare}, ${place.subLocality}, ";
      });
      _getAddressFromLatLng();
    } catch (e) {
      print(e);
    }
  }
}
