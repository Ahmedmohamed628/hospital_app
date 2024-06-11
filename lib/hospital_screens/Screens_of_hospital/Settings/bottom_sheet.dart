import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Settings/update_profile.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../theme/theme.dart';

class BottomSheetSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProfilePage.routeName);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(LineAwesomeIcons.edit),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text('Edit profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15)),
            ]),
            style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.senderMessageColor),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}
