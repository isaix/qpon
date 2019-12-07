import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key key, this.currentUser}) : super(key: key);
  final FirebaseUser currentUser; 
  //widget.currentUser.uid

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerView> {
  String barcode = "";

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
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print('BARCODE RESULT' + barcode);
      setState(() => this.barcode = barcode);
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
}
