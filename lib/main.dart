import 'package:ambulance/hospital_screens/Screens_of_hospital/Chat/Chat.dart';
import 'package:ambulance/hospital_screens/Screens_of_hospital/Hisorty/History.dart';
import 'package:ambulance/hospital_screens/Screens_of_hospital/Settings/Settings.dart';
import 'package:ambulance/hospital_screens/home_screen_hospital.dart';
import 'package:ambulance/hospital_screens/screen_hospital_registeration.dart';
import 'package:ambulance/observer_screens/home_screen_observer.dart';
import 'package:ambulance/observer_screens/screen_observer_registeration.dart';
import 'package:ambulance/patient_screens/Screens/Chat/Chat.dart';
import 'package:ambulance/patient_screens/Screens/Hisorty/History.dart';
import 'package:ambulance/patient_screens/Screens/Medications/Medications.dart';
import 'package:ambulance/patient_screens/Screens/Root/Root.dart';
import 'package:ambulance/patient_screens/Screens/Settings/Settings.dart';
import 'package:ambulance/patient_screens/homeScreen_patient.dart';
import 'package:ambulance/patient_screens/screen_patient_registeration.dart';
import 'package:ambulance/screen_selection/screen_selection.dart';
import 'package:ambulance/splash_screen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/login/login_screen.dart';
import 'authentication/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
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
        RootScreen.routeName: (context) => RootScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        HistoryScreenPatient.routeName: (context) => HistoryScreenPatient(),
        ChatScreenPatient.routeName: (context) => ChatScreenPatient(),
        MedicationScreen.routeName: (context) => MedicationScreen(),
        HomeScreenPatient.routeName: (context) => HomeScreenPatient(),
        ScreenPatientRegisteration.routeName: (context) =>
            ScreenPatientRegisteration(),
        ScreenSelection.routeName: (context) => ScreenSelection(),
        HomeScreenHospital.routeName: (context) => HomeScreenHospital(),
        ChatScreenHospital.routeName: (context) => ChatScreenHospital(),
        HistoryScreenHospital.routeName: (context) => HistoryScreenHospital(),
        SettingsScreenHospital.routeName: (context) => SettingsScreenHospital(),
        ScreenHospitalRegisteration.routeName: (context) =>
            ScreenHospitalRegisteration(),
        HomeScreenObserver.routeName: (context) => HomeScreenObserver(),
        ScreenObserverRegisteration.routeName: (context) =>
            ScreenObserverRegisteration(),
      },
    );
  }
}
