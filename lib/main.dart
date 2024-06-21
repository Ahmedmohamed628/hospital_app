import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/wating.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/Chat.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Settings/Settings.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Settings/update_profile.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/deaf/deaf.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/root/google_maps.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/hospital_screens/screen_hospital_registeration.dart';
import 'package:hospital/splash_screen/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'authentication/login/login_screen.dart';
import 'authentication/register/register_screen.dart';

List<CameraDescription>? cameras;

Future<void> initializeAppAndCameras() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDGoIsHdQjW9hidXSdbW3xS4YqKVGfYJGI',
      appId: '1:237732499396:android:fc5cf8ca28138255cfde91',
      messagingSenderId: '237732499396',
      projectId: 'emergency-app-da505',
      storageBucket: 'emergency-app-da505.appspot.com',
    ),
  );
  await initializeAppAndCameras();

  // await registerServices();
}

void main() async {
  await setup();

  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  // await Permission.notification.isDenied.then((valueOfPermission) {
  //   if(valueOfPermission)
  //   {
  //     Permission.notification.request();
  //   }
  // });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,

      //RegisterScreen.routeName //ScreenSelection.routeName

      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreenHospital.routeName: (context) => HomeScreenHospital(),
        ChatScreenHospital.routeName: (context) => ChatScreenHospital(),
        // HistoryScreenHospital.routeName: (context) => HistoryScreenHospital(),
        SettingsScreenHospital.routeName: (context) => SettingsScreenHospital(),
        ScreenHospitalRegisteration.routeName: (context) =>
            ScreenHospitalRegisteration(),
        DeafScreenHospital.routeName: (context) => DeafScreenHospital(),
        ProfilePage.routeName: (context) => ProfilePage(),
        GoogleMapsForHospital.routeName: (context) => GoogleMapsForHospital(),
        WaitingScreen.routeName: (context) => WaitingScreen(),
      },
    );
  }
}
