import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/Chat.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Hisorty/History.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Settings/Settings.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/hospital_screens/screen_hospital_registeration.dart';
import 'package:hospital/splash_screen/splash_screen.dart';
import 'authentication/login/login_screen.dart';
import 'authentication/register/register_screen.dart';

void main() async {
  await setup();
  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDGoIsHdQjW9hidXSdbW3xS4YqKVGfYJGI',
      appId: '1:237732499396:android:fc5cf8ca28138255cfde91',
      messagingSenderId: '867907366273',
      projectId: 'emergency-app-da505',
      storageBucket: 'emergency-app-da505.appspot.com',
    ),
  );
  // await registerServices();
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
        HistoryScreenHospital.routeName: (context) => HistoryScreenHospital(),
        SettingsScreenHospital.routeName: (context) => SettingsScreenHospital(),
        ScreenHospitalRegisteration.routeName: (context) =>
            ScreenHospitalRegisteration(),
      },
    );
  }
}
