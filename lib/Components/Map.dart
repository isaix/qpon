import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  @override
  State<MapComponent> createState() => MapComponentState();
}

class MapComponentState extends State<MapComponent> {
  Completer<GoogleMapController> _controller = Completer();
  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;

  Set<Marker> _markers = {};
  List<Placemark> placemark;

  CameraPosition _currentLocation;
  Set<Circle> circles;

  @override
  initState() {
    super.initState();

    _getCurrentLocation();
    _getNearbyLocations();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _currentLocation == null
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _currentLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refresh,
        label: Text('Refresh'),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  _refresh() {
    _getNearbyLocations();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentLocation = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 16);
        circles = Set.from([
          Circle(
            circleId: CircleId('_current_location'),
            center: LatLng(position.latitude, position.longitude),
            radius: 4000,
          )
        ]);
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getNearbyLocations() {

    Geolocator()
        .placemarkFromAddress("Nørre Farimagsgade 57, 1364 København")
        .then((List<Placemark> locations) {
          setState(() {
            _markers = locations.map((location) => Marker(
              // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(locations.toString()),
              position: LatLng(location.position.latitude, location.position.longitude),
              infoWindow: InfoWindow(
                title: "Barkowski",
                snippet: '${location.thoroughfare} ${location.subThoroughfare}',
              ),
              icon: BitmapDescriptor.defaultMarker,
            )).toSet();
          });
    });
  }

}
