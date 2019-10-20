import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerState createState() => new _ScannerState();
}

class _ScannerState extends State<ScannerPage> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new MaterialButton(onPressed: scan, child: new Text("Scan")),
      padding: const EdgeInsets.all(8.0),
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
          this.barcode = 'The user did not grant the camera permission!';
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
