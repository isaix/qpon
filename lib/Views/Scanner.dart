import 'dart:convert';
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

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 30),
          child: Text(
            'In order to recieve your coupon, please scan the QR code presented to you by the store.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        RaisedButton(
          onPressed: scan,
          child: new Text("Scan QR code"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            '(For testing) Scanned code is: ' + barcode,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  /*
  Future sendNotification(
      String messageTitle, String messageBody, String storeToken, String myToken) async {
    final response = await Messaging.sendTo(
      title: messageTitle,
      body: messageBody,
      fcmToken: storeToken,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }
  */

  static Future sendNotification(String title, String message, String storeToken, String myToken, String userID) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key=AAAAgLYJ6Ss:APA91bGVLMjL00l7YzFPJIerp3aVpmiZDnozHIEJ4DEuD-FT0ifTQT_S7MpmZCaOi5PTTuNFNL64quQMbktec5V-mduFJ_pOQCYqfbZ6toMEFfVX_H9RLAvGTrofiwLIy2tg1M2fjMj8",
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
              storeDescription = f.data['name'] + " - " + f.data['category'];
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
                sendNotification("Coupon Request", "Test", storeToken, myToken, widget.currentUserID);
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
