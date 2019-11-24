import 'package:flutter/material.dart';

class CardComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CardComponentState();
  }
}

class _CardComponentState extends State<CardComponent> {
  var _selected;
  var _height;

  _handleClick() {
    setState(() {
      _height = 100.0;
    });
  }

  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 5),
              curve: Curves.fastOutSlowIn,
              height: _height == null ? null : _height,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text(
                      'Barkowski',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(_height.toString()),
                  ),
                ],
              ),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: _height == null ? Text('EXPAND') : Text("CLOSE"),
                    onPressed: () => _height == null ? _handleClick() : setState(() => {_height = null}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
