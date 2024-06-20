import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/Chat.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Settings/Settings.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/ambulance/ambulance.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/root/root.dart';
import 'package:hospital/theme/theme.dart';

import 'Screens_of_hospital/deaf/deaf.dart';
import 'Screens_of_hospital/root/root.dart';

class HomeScreenHospital extends StatefulWidget {
  static const String routeName = 'Home-screen-hospital';

  @override
  State<HomeScreenHospital> createState() => _HomeScreenHospitalState();
}

class _HomeScreenHospitalState extends State<HomeScreenHospital> {
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: MyTheme.redColor,
        ),
        child: BottomAppBar(
          color: MyTheme.redColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 8,
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            selectedItemColor: MyTheme.whiteColor,
            unselectedItemColor: MyTheme.grayColor,
            onTap: (index) {
              selectedIndex = index;

              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat, size: 22), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.medication, size: 22), label: 'Ambulance'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 22), label: 'Home'),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.history, size: 22), label: 'History'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sign_language, size: 22), label: 'Deaf'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings, size: 22), label: 'Settings'),
            ],
          ),
        ),
      ),
      body: tabsHospital[selectedIndex],
    );
  }

  List<Widget> tabsHospital = [
    ChatScreenHospital(),
    AmbulanceScreenHospital(),
    RootScreenHospital(),
    // HistoryScreenHospital(),
    DeafScreenHospital(),
    SettingsScreenHospital()
  ];
}
