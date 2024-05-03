import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SettingsScreenHospital extends StatelessWidget {
  static const String routeName = 'settings-screen-hospital';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title: Text('Approval', style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
      ),
      backgroundColor: MyTheme.whiteColor,
    );
  }
}
