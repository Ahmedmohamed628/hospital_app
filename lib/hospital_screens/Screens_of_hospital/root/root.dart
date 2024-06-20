import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/root/google_maps.dart';
import 'package:hospital/theme/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../my_location_manager.dart';
import '../../../pushNotification/push_notification_system.dart';
import '../../../push_notification/push_notification_system.dart';

class RootScreenHospital extends StatefulWidget {
  static const String routeName = 'Root';

  @override
  State<RootScreenHospital> createState() => _RootScreenHospitalState();
}

class _RootScreenHospitalState extends State<RootScreenHospital> {
  initializePushNotificationSystem() {
    PushNotificationSystem notificationSystem = PushNotificationSystem();
    notificationSystem.generateDeviceRegistrationToken();
    notificationSystem.startListeningForNewNotification(context);
  }

  @override
  MyLocationManager locationManager = MyLocationManager();

  void initState() {
    super.initState();
    requestPermission();
    initializePushNotificationSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
        backgroundColor: MyTheme.redColor,
      ),
      backgroundColor: MyTheme.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(GoogleMapsForHospital.routeName);
                },
                child: Lottie.asset('assets/images/doctor.json')),
            Text("No requests yet.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    bool isLocationServiceEnabled = await locationManager.isServiceEnabled();
    if (!isLocationServiceEnabled) {
      await locationManager.requestService();
    }

    bool isLocationPermissionDenied =
        await Permission.locationWhenInUse.isDenied;
    if (isLocationPermissionDenied) {
      await Permission.locationWhenInUse.request();
    }

    bool isNotificationPermissionDenied =
        await Permission.notification.isDenied;
    if (isNotificationPermissionDenied) {
      await Permission.notification.request();
    }
  }
}

//   requestPermission() async {
//     await locationManager.isServiceEnabled();
//     await locationManager.requestService();
//     await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
//       if (valueOfPermission) {
//         Permission.locationWhenInUse.request();
//       }
//     });

//     await Permission.notification.isDenied.then((valueOfPermission) {
//       if (valueOfPermission) {
//         Permission.notification.request();
//       }
//     });
//   }
// }

//todo: 3shan a5ly de tzhr lw mfesh requests lkn lw feh ygeeb container feh (yes.no) w lw 2bl yro7 3la google maps====>>
///      SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: MediaQuery.of(context).size.height*0.2,),
//             Lottie.asset('assets/images/doctor.json'),
//             Text("No requests yet.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
