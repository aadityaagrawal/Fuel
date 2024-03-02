import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  static const CameraPosition initiallocation = CameraPosition(
    target: LatLng(12.824299387212374, 80.0444816863494),
    zoom: 18,
  );

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Location _locationController = Location();
  LatLng? _currentP;

  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 18);
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionStatus;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionStatus = await _locationController.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _locationController.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(_currentP!);
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // Cancel the subscription to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentP == null
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.green[200],
            ),
          )
        : GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: MapScreen.initiallocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              const Marker(
                markerId: MarkerId("initial_location"),
                position: LatLng(12.824299387212374, 80.0444816863494),
                icon: BitmapDescriptor.defaultMarker,
              ),
              Marker(
                markerId: const MarkerId("current_location"),
                position: _currentP!,
                icon: BitmapDescriptor.defaultMarker,
              ),
            },
          );
  }
}
