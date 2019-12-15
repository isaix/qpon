//import 'dart:async';
//
//import 'package:Qpon/BLoC/bloc.dart';
//
//class LocationBloc implements Bloc {
//  Location _location;
//  Location get selectedLocation => _location;
//
//  // 1
//  final _locationController = StreamController<Location>();
//
//  // 2
//  Stream<Location> get locationStream => _locationController.stream;
//
//  // 3
//  void selectLocation(Location location) {
//    _location = location;
//    _locationController.sink.add(location);
//  }
//
//  // 4
//  @override
//  void dispose() {
//    _locationController.close();
//  }
//}