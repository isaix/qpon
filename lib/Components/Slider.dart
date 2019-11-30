import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderComponent extends StatelessWidget {
  final List slides;

  const SliderComponent({this.slides});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      aspectRatio: 21 / 9,
      viewportFraction: 0.92,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      initialPage: 0,
      items: (slides != null)
          ? slides.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
//                        padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(i)),
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              );
            }).toList()
          : [],
    );
  }
}