import 'dart:convert';

import 'package:Qpon/Components/Counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:slider_button/slider_button.dart';

class StoreRequest extends StatefulWidget {

  const StoreRequest({Key key, this.userToken}) : super(key: key);
  final String userToken;

  @override
  _StoreRequestState createState() => _StoreRequestState();
}

class _StoreRequestState extends State<StoreRequest> {
  int _counterValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QPON'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Text(
                  'Coupon Request',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Counter(
                initialValue: _counterValue,
                minValue: 0,
                maxValue: 10000,
                step: 1,
                decimalPlaces: 0,
                onChanged: (value) {
                  setState(() {
                    _counterValue = value;
                  });
                },
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: SliderButton(
                  action: () {
                    if(_counterValue < 1){
                      _showDialog();
                    }
                    else{
                      sendReturnNotification("Coupon Response", "Test", widget.userToken, _counterValue);
                      Navigator.of(context).pop();
                    }
                  },
                  label: Text(
                    "Slide to Confirm",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  shimmer: false,
                  dismissible: false,
                  height: 60,
                  width: 300,
                  alignLabel: Alignment(0.1, 0),
                  vibrationFlag: false,
                  icon: Icon(
                    Icons.chevron_right,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  static Future sendReturnNotification(String title, String message, String userToken, int couponCount) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key=AAAAgLYJ6Ss:APA91bGVLMjL00l7YzFPJIerp3aVpmiZDnozHIEJ4DEuD-FT0ifTQT_S7MpmZCaOi5PTTuNFNL64quQMbktec5V-mduFJ_pOQCYqfbZ6toMEFfVX_H9RLAvGTrofiwLIy2tg1M2fjMj8",
      };
      var request = {
        'to': userToken,
        'notification': {'title': title, 'body': message},
        'data': {
          'click_action': "FLUTTER_NOTIFICATION_CLICK",
          'couponCount': couponCount
        }
      };

      var client = new Client();
      var response =
          await client.post(url, headers: header, body: json.encode(request));
    } catch (e) {
      print(e);
    }
  }

  void _showDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Not Enough Coupons"),
          content: new Text("Please select the desired amount of coupons to grant."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}
