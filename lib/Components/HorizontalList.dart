import 'package:flutter/material.dart';

var list = [1, 2, 3, 4, 1, 2, 3, 4];

class HorizontalList extends StatelessWidget {
  final List items;

  const HorizontalList({
    Key key,
    @required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 70.0,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Flexible(
                    child: Image(
                        image: AssetImage('assets/images/icon$index@3x.png')),
                  )
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 12,
              );
            },
            itemCount: list.length));
  }
}
