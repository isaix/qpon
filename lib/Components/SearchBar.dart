import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const SearchBar({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
        child: SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
//                          borderSide: BorderSide(color: Colors.red, style: )
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}