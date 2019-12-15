import 'package:Qpon/Components/Card.dart';
import 'package:Qpon/Models/Category.dart';
import 'package:Qpon/Models/Store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

final databaseReference = Firestore.instance;

class CategoryView extends StatefulWidget {
  final Category category;

  @override
  CategoryState createState() => CategoryState();

  const CategoryView({Key key, this.category}) : super(key: key);
}

class CategoryState extends State<CategoryView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  List<Store> _stores;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.category.label}"),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: ListView(
                children: _stores != null
                    ? _stores.isNotEmpty
                        ? _stores
                            .map((store) => CardComponent(store: store))
                            .toList()
                        : [
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.85,
                              child: Text("No places found that serve ${widget.category.label.toLowerCase()}"),
                            )
                          ]
                    : List.generate(3, (i) {
                        return Container(
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
                        );
                      }))));
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _getLocationsAndCategories(position);
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
          _stores = list
              .where((Store store) => store.category.id == widget.category.id)
              .toList();
        });
      }
    });
  }
}
