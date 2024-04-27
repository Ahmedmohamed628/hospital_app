import 'package:flutter/material.dart';
import 'package:hospital/theme/theme.dart';

class AmbulanceScreenHospital extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title: Text('Ambulance', style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
      ),
      backgroundColor: MyTheme.whiteColor,
    );
  }
}
