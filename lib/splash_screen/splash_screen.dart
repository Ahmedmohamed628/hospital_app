import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_screen.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/hospital_screens/wating.dart';
import 'package:hospital/theme/theme.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash screen';

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.of(context).pushReplacementNamed(LoginScreen.routeName)
          : Navigator.of(context).pushReplacementNamed(WaitingScreen.routeName);
    });
    return Scaffold(
        backgroundColor: MyTheme.redColor,
        body: Center(
          child: Lottie.asset(
            'assets/images/ambulance_splash.json',
          ),
        ));
  }
}
