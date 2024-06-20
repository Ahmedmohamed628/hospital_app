import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails
{
  String? tripID;

  LatLng? pickUpLatLng;
  String? pickupAddress;

  LatLng? destinationLatLng;
  String? destinationAddress;

  String? userName;
  String? userPhone;


  TripDetails({
    this.tripID,
    this.pickUpLatLng,
    this.pickupAddress,
    this.destinationLatLng,
    this.destinationAddress,
    this.userName,
    this.userPhone,
  });
}