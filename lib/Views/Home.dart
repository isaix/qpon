import 'package:Qpon/Components/HorizontalList.dart';
import 'package:Qpon/Components/Shimmer.dart';
import 'package:Qpon/Components/Slider.dart';
import 'package:Qpon/Models/Category.dart';
import 'package:Qpon/Models/Store.dart';
import 'package:Qpon/Views/Category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Qpon/Components/Card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

final databaseReference = Firestore.instance;

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  List _slides = [];
  List<Store> _nearbyLocations;
  List<Category> _categories;

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
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - 10,
              ),
              child: Column(children: <Widget>[
                SliderComponent(slides: _slides),
                HorizontalList(
                    height: 70,
                    title: "Categories",
                    items: _categories != null
                        ? _categories.map((i) {
                            return Column(
                              children: <Widget>[
                                Flexible(
                                    child: GestureDetector(
                                      child: Image(image: NetworkImage(i.imageUrl)),
                                      onTap: () {
                                        Navigator.of(context, rootNavigator: true).push(
                                          CupertinoPageRoute<bool>(
//                                            fullscreenDialog: true,
                                            builder: (BuildContext context) => CategoryView(category: i),
                                          ),
                                        );
                                      },
                                  ),
                                )
                              ],
                            );
                          }).toList()
                        : List.generate(6, (i) {
                            return AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: Colors.white70,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width - 40,
                                ),
                              ),
                            );
                          })),
                HorizontalList(
                    height: 150,
                    title: "Nearby Locations",
                    items: _nearbyLocations != null
                        ? _nearbyLocations
                            .map<CardComponent>((Store store) => CardComponent(
                                  store: store,
                                  stamps: 0,
                                ))
                            .toList()
                        : [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              margin: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.white70,
                                  child: new Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 124.0,
                                        margin: new EdgeInsets.only(left: 46.0),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.grey,
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      Container(
                                        margin: new EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        alignment: FractionalOffset.centerLeft,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                          height: 92.0,
                                          width: 92.0,
                                        ),
                                      ),

                                    ],
                                  )),
                            ),
                          ]),
                RaisedButton(
                  onPressed: _saveLatLong,
                )
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
      _getLocationsAndCategories(_currentPosition);
    }).catchError((e) {
      print(e);
    });
  }

  _getLocationsAndCategories(currentPosition) {
    databaseReference
        .collection("stores")
        .getDocuments()
        .then((snapshot) async {
      List<Store> list = snapshot.documents
          .map<Store>(
              (document) => Store.fromMap(document.data, document.documentID))
          .toList();

      QuerySnapshot datasnapshot =
          await databaseReference.collection("categories").getDocuments();
      List<Category> categories = datasnapshot.documents
          .map<Category>((document) =>
              Category.fromMap(document.data, document.documentID))
          .toList();

      list.forEach((store) async => {
            store.distance = await Geolocator().distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                store.latitude,
                store.longitude),
            store.category = categories
                .singleWhere((category) => category.id == store.category.id)
          });


      if (this.mounted) {
        setState(() {
          _nearbyLocations = list.map<Store>((Store store) => store).toList();
          _categories = categories;
        });
      }
    });
  }
}
