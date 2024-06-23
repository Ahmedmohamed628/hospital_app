import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital/model/trip_details.dart';

class NewTripPage extends StatefulWidget {
  static const String routeName = 'new_trip_page';
  TripDetails? newTripDetailsInfo;
  NewTripPage({super.key, this.newTripDetailsInfo});
  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  static const CameraPosition googlePlexInitialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfHospital;
  double googleMapPaddingFromBottom = 0;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();

  getCurrentLiveLocationOfHospital() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfHospital = positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(currentPositionOfHospital!.latitude,
        currentPositionOfHospital!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: googleMapPaddingFromBottom),
            mapType: MapType.normal,
            initialCameraPosition: googlePlexInitialPosition,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              // updateMapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);
              setState(() {
                googleMapPaddingFromBottom = 262;
              });
              var driverCurrentLocationLatLng = LatLng(currentPositionOfHospital!.latitude, currentPositionOfHospital!.longitude);
              var userPickUpLocationLatLng = widget.newTripDetailsInfo!.pickUpLatLng;
              getCurrentLiveLocationOfHospital();
              
            },
          ),
        ],
      ),
    );
  }
}
