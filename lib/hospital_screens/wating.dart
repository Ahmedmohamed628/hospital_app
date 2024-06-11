import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/authentication/login/login_screen.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/theme/theme.dart';
import 'package:lottie/lottie.dart';

class WaitingScreen extends StatefulWidget {
  static const routeName = '/waiting';

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {
    super.initState();
    _listenToUserStatusChanges();
  }

  void _listenToUserStatusChanges() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(user.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final userStatus = data['status'] as bool?;
          if (userStatus == true) {
            Navigator.pushReplacementNamed(
                context, HomeScreenHospital.routeName);
          } else if (userStatus == false) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title: Text('Wating for approval',
            style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Lottie.asset('assets/images/watingwatch.json')),
              ),
              Center(
                child: Text('Please wait for admin approval.'),
              ),
            ]),
      ),
    );
  }
}
