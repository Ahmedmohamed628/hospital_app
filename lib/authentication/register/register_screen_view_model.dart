import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_screen.dart';
import 'package:hospital/hospital_screens/wating.dart';
import 'package:hospital/authentication/register/register_navigator.dart';
import 'package:hospital/authentication/register/register_screen.dart';
import 'package:hospital/dialog_utils.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/model/my_user.dart';
import 'package:path/path.dart' as p;
import '../../firebase_utils.dart';
import '../../methods/common_methods.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  static User? userSignUp;
  var emailController = TextEditingController(text: 'elamal@gmail.com');
  var passwordController = TextEditingController(text: '123456');
  var nameController = TextEditingController(text: 'elamal');
  var phoneNumber = TextEditingController(text: '01228384694');
  var address = TextEditingController(text: 'alexandria');
  // todo: da le el hospital
  var doctorId = TextEditingController(text: '99');
  var doctorName = TextEditingController(text: 'ahmed');
  var gender = TextEditingController(text: 'Male');

  CommonMethods cMethods = CommonMethods();
  var formKey = GlobalKey<FormState>();

  //todo: hold data - handle logic
  late RegisterNavigator navigator;
  String? pfpURL;

  void register(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      //todo: show loading
      navigator.showMyLoading();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        //todo => da goz2 el information bta3t el hospital lw hsyvha de le real time database
        // DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("Hospital").child(FirebaseAuth.instance.currentUser!.uid);
        // Map hospitalDataMap = {
        //   //todo: => el photo yd5l el sora bta3to fe el database (real time)
        //   // "photo": urlOfUploadedImage,
        //   // "car_details": driverCarInfo,
        //   "doctorName": doctorName.text.trim(),
        //   "email": emailController.text.trim(),
        //   "phone": phoneNumber.text.trim(),
        //   "id": credential.user?.uid ?? '',
        //   "address": address.text.trim(),
        //   "hospitalName": nameController.text.trim(),
        //   "doctorId": doctorId.text.trim(),
        //   "gender": gender.text.trim(),
        //   "status": null,
        //   "pfpURL": pfpURL,
        //   "createdAt": Timestamp.now(),
        // };
        // usersRef.set(hospitalDataMap);
        // usersRef.onValue.listen((event) { });
        // print(credential.user?.uid ?? '');

        // String? id;
        // String? email;
        // String? hospitalName;
        // String? phoneNumber;
        // String? address;
        // String? doctorId;
        // String? doctorName;
        // String? gender;
        userSignUp = credential.user;
        final currentstatus = userSignUp;
        if (currentstatus != null && RegisterScreen.selectedImage != null) {
          pfpURL = await uplaodPfp(
              file: RegisterScreen.selectedImage!, Uid: currentstatus.uid);
        }
        MyUser myUser = MyUser(
          phoneNumber: phoneNumber.text,
          address: address.text,
          id: credential.user?.uid ?? '',
          hospitalName: nameController.text,
          email: emailController.text,
          doctorId: doctorId.text,
          doctorName: doctorName.text,
          gender: gender.text,
          status: null,
          pfpURL: pfpURL,
          createdAt: Timestamp.now(),
        );
        // var authProvider = Provider.of<AuthProvider>(context,listen: false);
        // authProvider.updateUser(myUser);

        //todo: lw 3ayz a3ml patient
        // Patient patient = Patient(
        //     nationalId: nationalId.text,
        //     id: credential.user?.uid??'',
        //     phoneNumber:phoneNumber.text,
        //     address: address.text,
        //     email: emailController.text,
        //     name: nameController.text,
        //     chronicDiseases: chronicDiseases.text,
        //     height: height.text,
        //     weight: weight.text,
        //     age: age.text,
        //     gender: gender.text);
        await FirebaseUtils.addUserToFireStore(myUser);
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show message
        // navigator.showMessage('Register Successfully');
        // if (myUser.status == null) {
        //   DialogUtils.showMessage(context,
        //       'Register Successfully wait for admin to accpet your account',
        //       title: 'Sign-Up', posActionName: 'ok', posAction: () {
        //     Navigator.of(context)
        //         .pushReplacementNamed(HomeScreenHospital.routeName);
        //   });
        //   // ignore: unrelated_type_equality_checks
        // } else if (myUser.status == true) {
        //   DialogUtils.showMessage(context, 'Register Successfully',
        //       title: 'Sign-Up', posActionName: 'ok', posAction: () {
        //     Navigator.of(context)
        //         .pushReplacementNamed(HomeScreenHospital.routeName);
        //   });
        // } else {
        //   DialogUtils.showMessage(
        //       context, 'Register Successfully but you are banned',
        //       title: 'Sign-Up', posActionName: 'ok', posAction: () {
        //     Navigator.of(context)
        //         .pushReplacementNamed(HomeScreenHospital.routeName);
        //   });
        // }
        DialogUtils.showMessage(context, 'Register Successfully',
            title: 'Sign-Up', posActionName: 'ok', posAction: () {
          DialogUtils.showMessage(
              context, 'Wait for admin approval and try log in later',
              title: 'Sign-Up', posActionName: 'ok', posAction: () {
            Navigator.pushReplacementNamed(context, WaitingScreen.routeName);
          });
        });
      } on FirebaseAuthException catch (e) {
        // print('this error is unknown ${e.code}');
        if (e.code == 'weak-password') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          navigator.showMessage('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          navigator.showMessage('The account already exists for that email.');
        } else if (e.code == 'network-request-failed') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          // navigator.showMessage('Your internet is not available. Check your connection and try again.');
          cMethods.displaySnackBar(
              'Your internet is not available. Check your connection and try again.',
              context);
        }
      } catch (e) {
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show message
        navigator.showMessage(e.toString());
      }
    }
  }

  Future<String?> uplaodPfp({required File file, required String Uid}) async {
    final firebaseStorage = FirebaseStorage.instance;
    Reference fileRef = firebaseStorage
        .ref('users/pfps')
        .child("${Uid}${p.extension(file.path)}");
    UploadTask task = fileRef.putFile(file);
    return task.then((p0) {
      if (p0.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }
}
