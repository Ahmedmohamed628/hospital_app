import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/theme/theme.dart';
import 'package:lottie/lottie.dart';

import '../authentication/component/custom_text_form_field.dart';

class ScreenHospitalRegisteration extends StatelessWidget {
  static const String routeName = 'screen-hospital';
  var doctorId = TextEditingController();
  var doctorName = TextEditingController();
  var gender = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.whiteColor,
      appBar: AppBar(
          backgroundColor: MyTheme.redColor,
          title: Text('Hospital', style: TextStyle(color: MyTheme.whiteColor)),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(HomeScreenHospital.routeName);
              },
              icon: Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Lottie.asset('assets/images/hospital_lottie.json')),

              //doctor id
              CustomTextFormField(
                label: 'Doctor id',
                controller: doctorId,
                suffixIcon: Icon(Icons.home_filled, color: MyTheme.redColor),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter a doctor id';
                  }
                  if (text.length < 14) {
                    return 'Enter a valid doctor id';
                  }
                  return null;
                },
              ),
              //doctor name
              CustomTextFormField(
                label: 'Doctor Name',
                controller: doctorName,
                prefixIcon: Icon(Icons.drive_file_rename_outline_sharp,
                    color: MyTheme.redColor),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter a your name doctor';
                  }
                  return null;
                },
              ),
              //gender
              CustomTextFormField(
                label: 'Gender', controller: gender,
                // mlhash suffixation icon??????????????????????????
                prefixIcon: Icon(Icons.perm_identity, color: MyTheme.redColor),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter your gender';
                  }
                  return null;
                },
              ),

              //nfs el moshkela leh el spacer error??????????????????????????????
              // SizedBox(height: MediaQuery.of(context).size.height*0.13),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // navigate to home screen patient
                    Navigator.of(context)
                        .pushReplacementNamed(HomeScreenHospital.routeName);
                  },
                  child: Text('Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.redColor,
                      padding: EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
