import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import '../hospital_screens/Screens_of_hospital/root/google_maps.dart';
Position? ambulanceCurrentPosition;

class CommonMethods extends ChangeNotifier {
  displaySnackBar(String message, BuildContext context) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // when hospital accept request (ambulance is busy)
  turnOffLocationUpdatesForHomePage(){
    positionStreamHomePage!.pause();
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
  }
  turnOnLocationUpdatesForHomePage() {
    positionStreamHomePage!.resume();

    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      ambulanceCurrentPosition!.latitude,
      ambulanceCurrentPosition!.longitude,
    );
  }
}
