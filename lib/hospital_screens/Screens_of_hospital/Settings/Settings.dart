import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_screen.dart';
import 'package:hospital/dialog_utils.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Settings/update_profile.dart';
import 'package:hospital/model/my_user.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hospital/model/my_user.dart';

import '../../../authentication/register/register_navigator.dart';
import '../../../methods/common_methods.dart';
import '../../../theme/theme.dart';
import 'bottom_sheet.dart';

class SettingsScreenHospital extends StatefulWidget {
  static const String routeName = 'settings-screen-hospital';

  @override
  State<SettingsScreenHospital> createState() => _SettingsScreenHospitalState();
}

class _SettingsScreenHospitalState extends State<SettingsScreenHospital> {
  CommonMethods cMethods = CommonMethods();
  bool isSwitched = false;
  late RegisterNavigator navigator;
  final userCurrent = FirebaseAuth.instance.currentUser;
  MyUser? userdata;
  String? userpfp;
  // sign out function
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userdata = await getUserDetails(userCurrent!.uid);
    userpfp = userdata!.pfpURL;
    setState(() {}); // Update the state after fetching the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title: Text('Profile', style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
      ),
      backgroundColor: MyTheme.whiteColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(children: [
                CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    child: ClipOval(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: userpfp != null
                            ? Image.network(userpfp!, fit: BoxFit.cover)
                            : Image.asset('assets/images/user.jpg',
                                fit: BoxFit.cover),
                      ),
                    )
                    // backgroundImage: selectedImage != null
                    //     ? FileImage(selectedImage!)
                    //     : AssetImage('assets/images/user.jpg')
                    //         as ImageProvider,
                    )
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.3,
                //   height: MediaQuery.of(context).size.height * 0.15,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(100),
                //     child: Image(
                //       image: AssetImage('assets/images/user.jpg'),
                //     ),
                //   ),
                // ),,
                ,
              ]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(userdata != null ? userdata!.hospitalName.toString() : "",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(userdata != null ? userdata!.email.toString() : "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              // SizedBox(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Navigator.of(context)
              //       //     .pushNamed(UpdateProfileScreen.routeName);
              //       Navigator.of(context).pushNamed(ProfilePage.routeName);
              //     },
              //     child: Text('Edit profile',
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.w400,
              //             fontSize: 15)),
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: MyTheme.senderMessageColor),
              //   ),
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              const Divider(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ListTile(
                tileColor: MyTheme.messageColor.withOpacity(0.1),
                onTap: () {
                  showBottomSheet();
                },
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.searchBarColor.withOpacity(0.6)),
                  child: Icon(LineAwesomeIcons.cog),
                ),
                title: Text('Settings',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                trailing: Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.searchBarColor.withOpacity(0.1)),
                  child: Icon(LineAwesomeIcons.angle_right,
                      color: Colors.grey, size: 18),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ListTile(
                tileColor: MyTheme.messageColor.withOpacity(0.1),
                onTap: () {
                  // _contactAdmin();
                },
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.redColor.withOpacity(0.1)),
                  child: Icon(LineAwesomeIcons.envelope),
                ),
                title: Text('Contact Admin',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                trailing: Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.searchBarColor.withOpacity(0.1)),
                  child: Icon(LineAwesomeIcons.angle_right,
                      color: Colors.grey, size: 18),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              //theme
              ListTile(
                tileColor: MyTheme.messageColor.withOpacity(0.1),
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.redColor.withOpacity(0.1)),
                  child: Icon(LineAwesomeIcons.paint_roller),
                ),
                title: Text('Theme',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                trailing: Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.searchBarColor.withOpacity(0.1)),
                  child: Switch(
                    activeColor: MyTheme.whiteColor,
                    activeThumbImage: AssetImage('assets/images/dark_mode.png'),
                    activeTrackColor: MyTheme.redColor,
                    inactiveThumbImage:
                        AssetImage('assets/images/light_mode.png'),
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = !isSwitched;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // sign out
              ListTile(
                tileColor: MyTheme.messageColor.withOpacity(0.1),
                onTap: () {
                  DialogUtils.showMessage(
                    context,
                    title: 'Sign_out ',
                    ' Are you sure to sign_out?',
                    barrierDismissible: false,
                    posActionName: 'yes',
                    posAction: () {
                      _signOut(context);
                      cMethods.displaySnackBar(
                          'Signed out successfully.', context);
                    },
                    negActionName: 'no',
                    negAction: () {},
                  );
                },
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyTheme.redColor.withOpacity(0.6)),
                  child: Icon(LineAwesomeIcons.alternate_sign_out),
                ),
                title: Text('Log_out',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<MyUser?> fetchUserFromFirestore(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(MyUser.collectionName)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return MyUser.fromFireStore(userDoc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<MyUser?> getUserDetails(String id) async {
    var usersnapshot = await FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (user, options) => user.toFireStore())
        .where("id", isEqualTo: id)
        .get();
    print(usersnapshot);

    // Correctly map each document snapshot to a MyUser object
    var userdata = usersnapshot.docs
        .map((doc) => MyUser.fromFireStore(doc.data().toFireStore()));

    return userdata.single;
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => BottomSheetSettings());
  }
}
