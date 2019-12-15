import 'package:Qpon/Models/Category.dart';
import 'package:Qpon/Models/Store.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CardComponent extends StatefulWidget {
  final Store store;
  final int stamps;

  const CardComponent({Key key, this.store, this.stamps}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CardComponentState();
  }
}

class _CardComponentState extends State<CardComponent> {
  @override
  Widget build(BuildContext context) {
    final cardThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: widget.store.category.imageUrl != null
            ? NetworkImage(widget.store.category.imageUrl)
            : AssetImage("assets/img/mars.png"),
        height: 92.0,
        width: 92.0,
      ),
    );

    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);

    Widget _cardValue({String value, String image}) {
      return new Row(children: <Widget>[
        new Image.asset(image, height: 12.0),
        new Container(width: 8.0),
        new Text(value, style: regularTextStyle),
      ]);
    }

    final cardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new AutoSizeText(
            '${widget.store.name}',
            style: headerTextStyle,
            maxLines: 1,
          ),
          new Container(height: 10.0),
          new Text(
              '${widget.store.address.street} ${widget.store.address.number}',
              style: subHeaderTextStyle),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: _cardValue(
                      value: '${formatDistance(widget.store.distance)}',
                      image: 'assets/img/ic_distance.png')),
              widget.stamps != null
                  ? new Expanded(
                      child: _cardValue(
                          value: '${widget.stamps} / 10',
                          image: 'assets/img/ic_gravity.png'))
                  : Container()
            ],
          ),
        ],
      ),
    );

    final card = new Container(
      child: cardContent,
      height: 124.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
//          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            card,
            cardThumbnail,
          ],
        ));
  }
}

formatDistance(double distance) {
  if (distance == null) return "";
  if (distance >= 1000.0) return '${(distance / 1000.0).toStringAsFixed(2)} Km';
  return '${distance.toStringAsFixed(2)} M';
}
