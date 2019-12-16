import 'dart:convert';
import 'package:Qpon/Components/Card.dart';
import 'package:Qpon/Components/HorizontalList.dart';
import 'package:Qpon/Models/Category.dart';
import 'package:Qpon/Models/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key key, this.currentUserID}) : super(key: key);
  final String currentUserID;
  //widget.currentUser.uid

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String barcode = "";
  final Firestore ref = Firestore.instance;
  List<Store> _storesList;

  @override
  initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                child: RaisedButton(
                  onPressed: scan,
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          'Scan',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: StreamBuilder<QuerySnapshot>(
            stream: ref
                .collection('users')
                .document(widget.currentUserID)
                .collection('coupons')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data available.');
              } else if (_storesList == null) {
                return Text('Loading');
              } else if (_storesList[0].id == null) {
                return Text('Loading');
              } else if (_storesList[0].category == null) {
                return Text('Loading');
              } else {
                return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.documents[index];
                    Store store;
                    _storesList.forEach((s) {
                      if (s.storeUserID == documentSnapshot.documentID) {
                        store = s;
                      }
                    });
                    //return Text('hej' + store.id);
                    return GestureDetector(
                      child: CardComponent(
                          store: store, stamps: documentSnapshot['count']),
                      onTap: () {
                        _redeem10Coupons(documentSnapshot['count'], documentSnapshot.documentID);
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void _redeem10Coupons(int count, String storeID) {
    if (count < 10) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error"),
            content: new Text("You need 10 coupons to redeem them."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Warning!"),
            content: new Text("You are about to redeem 10 coupons. Are you sure? \n\nMake sure you are present at the store, and that they approve beforehand."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Redeem"),
                onPressed: () {
                  Navigator.of(context).pop();
                  confirmRedeemCoupons(count, storeID);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void confirmRedeemCoupons(int count, String storeID){

    int newCount = count - 10;
    ref.collection('users').document(widget.currentUserID).collection('coupons').document(storeID).setData({"count":newCount});

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Congratulations"),
            content: new Text("You have successfully redeemed 10 coupons.\n\nEnjoy your reward."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  static Future sendNotification(String title, String message,
      String storeToken, String myToken, String userID) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAgLYJ6Ss:APA91bGVLMjL00l7YzFPJIerp3aVpmiZDnozHIEJ4DEuD-FT0ifTQT_S7MpmZCaOi5PTTuNFNL64quQMbktec5V-mduFJ_pOQCYqfbZ6toMEFfVX_H9RLAvGTrofiwLIy2tg1M2fjMj8",
      };
      var request = {
        'to': storeToken,
        'notification': {'title': title, 'body': message},
        'data': {
          'click_action': "FLUTTER_NOTIFICATION_CLICK",
          'returnToken': myToken,
          'userID': userID
        }
      };

      var client = new Client();
      var response =
          await client.post(url, headers: header, body: json.encode(request));
    } catch (e) {
      print(e);
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print('BARCODE RESULT' + barcode);
      setState(() => this.barcode = barcode);

      String storeToken, myToken, storeDescription = "", storeID;
      bool idMatch = false;

      //check if scanned store exists, and get the token
      await ref
          .collection("users")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((d) {
          if (d.documentID == barcode && d.data['role'] == 'Store') {
            idMatch = true;
            storeToken = d.data['token'];
            storeID = d.data['storeID'];
          } else if (d.documentID == widget.currentUserID) {
            myToken = d.data['token'];
          }
          print("id: " + d.documentID + " role: " + d.data['role']);
        });
      });

      print("THE ID OF THE STORE: " + storeID);

      if (idMatch) {
        //get store information
        await ref
            .collection("stores")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            if (f.documentID == storeID) {
              storeDescription = f.data['name'];
            } else {
              print("false");
            }
          });
        });

        _storeFoundAlert(storeDescription, storeToken, myToken);
      } else {
        _noStoreFoundAlert();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant camera permissions!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void _storeFoundAlert(
      String storeDescription, String storeToken, String myToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Store Found"),
          content: new Text(storeDescription),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Send Request"),
              onPressed: () {
                sendNotification("Coupon Request", "Test", storeToken, myToken,
                    widget.currentUserID);
                Navigator.of(context).pop();
                _waitingForResponse();
              },
            ),
          ],
        );
      },
    );
  }

  void _waitingForResponse() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: new CircularProgressIndicator(),
                ),
                new Text("Waiting for Store"),
              ],
            ),
          ),
        );
      },
    );
  }

  void _noStoreFoundAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("This store does not exist."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    ref.collection("stores").getDocuments().then((snapshot) async {
      List<Store> list = snapshot.documents
          .map<Store>(
              (document) => Store.fromMap(document.data, document.documentID))
          .toList();

      list.forEach((s) {
        print("ID: " + s.id);
      });

      QuerySnapshot datasnapshot =
          await ref.collection("categories").getDocuments();
      List<Category> categories = datasnapshot.documents
          .map<Category>((document) =>
              Category.fromMap(document.data, document.documentID))
          .toList();

      list.forEach((store) async {
        store.distance = await Geolocator().distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            store.latitude,
            store.longitude);

        store.category = categories
            .singleWhere((category) => category.id == store.category.id);
      });

      await ref
          .collection("users")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          print('DATA: ${f.data}}');
          if (f.data['role'] == 'Store') {
            list.forEach((s) {
              if (s.id == f.data['storeID']) {
                s.storeUserID = f.documentID;
                print('setting user id');
              }
            });
          }
        });
      });

      if (this.mounted) {
        setState(() {
          _storesList = list.map<Store>((Store store) => store).toList();
        });
      }
    });
  }
}
