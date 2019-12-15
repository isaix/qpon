import 'package:geolocator/geolocator.dart';

class AppState {
  final Position currentLocation;

  AppState(this.currentLocation);

  factory AppState.initial() => AppState(null);
}
