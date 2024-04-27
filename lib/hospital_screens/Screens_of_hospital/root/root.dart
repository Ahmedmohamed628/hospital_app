import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/theme/theme.dart';

class RootScreenHospital extends StatefulWidget {
  static const String routeName = 'Root';

  @override
  State<RootScreenHospital> createState() => _RootScreenHospitalState();
}

class _RootScreenHospitalState extends State<RootScreenHospital> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Home", style: TextStyle(color: MyTheme.whiteColor)),
          centerTitle: true,
          backgroundColor: MyTheme.redColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(HomeScreenHospital.routeName);
              },
              icon: Icon(Icons.arrow_back, color: MyTheme.whiteColor))),
      backgroundColor: MyTheme.whiteColor,
    );
  }
}
