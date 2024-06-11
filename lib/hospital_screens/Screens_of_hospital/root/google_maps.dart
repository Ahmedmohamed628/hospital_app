import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../theme/theme.dart';

String googleMapKey = 'AIzaSyDGoIsHdQjW9hidXSdbW3xS4YqKVGfYJGI';
StreamSubscription<Position>? positionStreamHomePage;
StreamSubscription<Position>? positionStreamNewTripPage;

class GoogleMapsForHospital extends StatefulWidget {
  static const String routeName = 'google-maps-screen-for-hospital';

  @override
  State<GoogleMapsForHospital> createState() => _GoogleMapsForHospitalState();
}

class _GoogleMapsForHospitalState extends State<GoogleMapsForHospital> {
  var nameController = TextEditingController(text: 'ahmed');
  var phoneNumber = TextEditingController(text: '01228384694');
  var doctorId = TextEditingController(text: '99');
  var doctorName = TextEditingController(text: 'Mohammed');
  var emailController = TextEditingController(text: 'ahmed.mohamed7@gmail.com');
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfHospital;
  Color colorToShow = Colors.green;
  String titleToShow = "Go online now";
  bool isHospitalAvailable = false;

  // de ms2ola 3n el real time data base
  DatabaseReference? newTripRequestReference;

  static const CameraPosition googlePlexInitialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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

  goOnlineNow() {
    //all Hospitals who are Available for new requests
    // geofire : bt3ml track l locations fe el real time database
    Geofire.initialize("onlineHospitals");

    // hna by5zn fe el id bta3 el user el (latitude w el longitude) bto3o
    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      currentPositionOfHospital!.latitude,
      currentPositionOfHospital!.longitude,
    );

    // hna by5znha fe le data base (real time)
    newTripRequestReference = FirebaseDatabase.instance
        .ref()
        .child("Hospital")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("newTripStatus");
    // Map driverDataMap ={
    //   // "photo": pfp,
    //   // "car_details": driverCarInfo,
    //   "name": doctorName.text.trim(),
    //   "email": emailController.text.trim(),
    //   "phone": phoneNumber.text.trim(),
    //   "id": FirebaseAuth.instance.currentUser?.uid??'',
    // };
    // usersRef.set(driverDataMap);
    newTripRequestReference!.set("waiting");
    // newTripRequestReference!.set(driverDataMap);

    newTripRequestReference!.onValue.listen((event) {});
  }

  setAndGetLocationUpdates() {
    positionStreamHomePage =
        Geolocator.getPositionStream().listen((Position position) {
      currentPositionOfHospital = position;

      if (isHospitalAvailable == true) {
        Geofire.setLocation(
          FirebaseAuth.instance.currentUser!.uid,
          currentPositionOfHospital!.latitude,
          currentPositionOfHospital!.longitude,
        );
      }

      LatLng positionLatLng = LatLng(position.latitude, position.longitude);
      controllerGoogleMap!
          .animateCamera(CameraUpdate.newLatLng(positionLatLng));
    });
  }

  goOfflineNow() {
    //stop sharing driver live location updates
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);

    //stop listening to the newTripStatus
    newTripRequestReference!.onDisconnect();
    newTripRequestReference!.remove();
    newTripRequestReference = null;
  }

  // initializePushNotificationSystem(){
  //   PushNotificationSystem notificationSystem = PushNotificationSystem();
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   initializePushNotificationSystem();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title: Text('Map', style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              LineAwesomeIcons.angle_left,
              color: MyTheme.whiteColor,
            )),
      ),
      body: Stack(
        children: [
          /// google maps
          GoogleMap(
            padding: EdgeInsets.only(top: 105),
            mapType: MapType.normal,
            initialCameraPosition: googlePlexInitialPosition,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              // updateMapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);
              getCurrentLiveLocationOfHospital();
            },
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: double.infinity,
            color: Colors.black54,
          ),

          ///go online and offline button
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return Container(
                          decoration:
                              BoxDecoration(color: Colors.black54, boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ]),
                          height: 221,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  (!isHospitalAvailable)
                                      ? "GO ONLINE NOW"
                                      : "GO OFFLINE NOW",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 21,
                                ),
                                Text(
                                  (!isHospitalAvailable)
                                      ? "You are about to go online, you will become available to receive trip requests from patients."
                                      : "You are about to go offline, you will stop receiving new trip requests from patient.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white30,
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("BACK"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!isHospitalAvailable) {
                                            //go online
                                            goOnlineNow();

                                            //get HospitalDriver location updates
                                            setAndGetLocationUpdates();

                                            Navigator.pop(context);

                                            setState(() {
                                              colorToShow = Colors.pink;
                                              titleToShow = "GO OFFLINE NOW";
                                              isHospitalAvailable = true;
                                            });
                                          } else {
                                            //go offline
                                            goOfflineNow();

                                            Navigator.pop(context);

                                            setState(() {
                                              colorToShow = Colors.green;
                                              titleToShow = "GO ONLINE NOW";
                                              isHospitalAvailable = false;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              (titleToShow == "GO ONLINE NOW")
                                                  ? Colors.green
                                                  : Colors.pink,
                                        ),
                                        child: const Text(
                                          "CONFIRM",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    titleToShow,
                    style: TextStyle(color: MyTheme.whiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorToShow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
