import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerComponent extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerComponent(
      {Key key, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red
          ),
          height: height,
          width: width,
        ),
      ),
    );
  }
}