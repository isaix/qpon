import 'package:geolocator/geolocator.dart';

/// Actions with Payload
class UpdateLocationAction {
  final Position payload;
  UpdateLocationAction(this.payload);
}