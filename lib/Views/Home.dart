import 'package:Qpon/Components/HorizontalList.dart';
import 'package:Qpon/Components/Slider.dart';
import 'package:Qpon/Models/Store.dart';
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
  List<Store> _nearbyLocations = <Store>[];

  @override
  initState() {
    super.initState();
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
                    items: _nearbyLocations
                        .map<CardComponent>((Store store) => CardComponent(
                              title: store.name,
                              address:
                                  '${store.address.street} ${store.address.number}',
                              distance: store.distance,
                              stamps: 0,
                            ))
                        .toList()),
                RaisedButton(onPressed: _saveLatLong)
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
      if (this.mounted) {
        setState(() {
          _slides = snapshot.data["slider"];
        });
      }
    });
  }

  _saveLatLong() {
    databaseReference.collection("stores").getDocuments().then((snapshot) {
      List<Store> list = snapshot.documents
          .map<Store>(
              (document) => Store.fromMap(document.data, document.documentID))
          .toList();

      list.forEach((Store store) async => {
            Geolocator()
                .placemarkFromAddress(
                    '${store.address.street} ${store.address.number}, ${store.address.city} ${store.address.zipcode}')
                .then((List<Placemark> locations) => {
                      store.latitude = locations.single.position.latitude,
                      store.longitude = locations.single.position.longitude,
                      databaseReference
                          .collection('stores')
                          .document(store.id)
                          .updateData(store.toJson())
                    })
          });
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (this.mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
      _getLocations(_currentPosition);
    }).catchError((e) {
      print(e);
    });
  }

  _getLocations(currentPosition) {
    databaseReference.collection("stores").getDocuments().then((snapshot) {
      List<Store> list = snapshot.documents
          .map<Store>(
              (document) => Store.fromMap(document.data, document.documentID))
          .toList();

      list.forEach((store) async => {
            store.distance = await Geolocator().distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                store.latitude,
                store.longitude)
          });

      if (this.mounted) {
        setState(() {
          _nearbyLocations = list.map<Store>((Store store) => store).toList();
        });
      }
    });
  }
}
