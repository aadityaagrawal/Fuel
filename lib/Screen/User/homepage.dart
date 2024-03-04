import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Screen/Orders/Booking_Screen.dart';
import 'package:fuel/Widgets/drawer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService auth = AuthService();
  Location locationController = Location();
  LatLng? _currentP;
  CameraPosition initiallocation = const CameraPosition(
    target: LatLng(12.824299387212374, 80.0444816863494),
    zoom: 18,
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 18);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await locationController.serviceEnabled();

    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionStatus = await locationController.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await locationController.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = locationController.onLocationChanged.listen(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FuelZapp",
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _currentP == null
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.green[200],
            ),
          )
        : GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: initiallocation,
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
                position: _currentP ?? const LatLng(0, 0),
                icon: BitmapDescriptor.defaultMarker,
              ),
            },
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>  OrderScreen(location: _currentP),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF4F6F52),
                  minimumSize: Size(
                    MediaQuery.sizeOf(context).width,
                    40,
                  )),
              child: const Text(
                "Order Now",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}


