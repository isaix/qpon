import 'package:flutter/material.dart';

@immutable
class FirebaseMessage{
  final String title;
  final String body;

  const FirebaseMessage({
    @required this.title,
    @required this.body,
  });
}