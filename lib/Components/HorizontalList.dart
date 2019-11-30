import 'package:flutter/material.dart';

var list = [1, 2, 3, 4, 1, 2, 3, 4];

class HorizontalList extends StatelessWidget {
  final List items;
  final String title;
  final double height;

  const HorizontalList({Key key, @required this.items, @required this.title, @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: height,
              child: ListView.separated(
                shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return items[index];
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: items.length),
            )
          ],
        ));
  }
}