import 'dart:convert';
import 'package:Qpon/Models/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key key, this.currentUserID}) : super(key: key);
  final String currentUserID;
  //widget.currentUser.uid

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerView> {
  String barcode = "";
  final Firestore ref = Firestore.instance;
  List<Store> storesList;

  @override
  initState() {
    super.initState();
    _getStoreInformation();
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
                    EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
                child: RaisedButton(
                  onPressed: (){
                    print('hej');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Redeem'),
                      ),
                      Icon(Icons.card_giftcard)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
                child: RaisedButton(
                  onPressed: scan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Scanner'),
                      ),
                      Icon(Icons.camera_alt)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
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
            } else if (storesList == null) {
              return Text('Loading');
            } else if (storesList[0].userID == null) {
              return Text('Loading');
            } else {
              return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data.documents[index];
                  String name = ' ';
                  storesList.forEach((s) {
                    if (s.userID == documentSnapshot.documentID) {
                      name = s.name;
                    }
                  });

                  return buildItem(documentSnapshot, name);
                },
              );
            }
          },
        )
      ],
    );
  }

  Card buildItem(DocumentSnapshot documentSnapshot, String name){
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF333366)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0,),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(
                  width: 1.0,
                  color: Colors.white24,
                ),
              ),
            ),
            child: Icon(Icons.category, color: Colors.white,),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          trailing: Text(
            'Coupons: ' + documentSnapshot.data['count'].toString(),
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  void _getStoreInformation() async {
    await ref
        .collection("stores")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      setState(() {
        storesList = snapshot.documents
            .map<Store>(
                (document) => Store.fromMap(document.data, document.documentID))
            .toList();
      });
    });

    await ref.collection("users").getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print('DATA: ${f.data}}');
        if (f.data['role'] == 'Store') {
          storesList.forEach((s) {
            if (s.id == f.data['storeID']) {
              s.userID = f.documentID;
              print('setting user id');
            }
          });
        }
      });
    });
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
}
