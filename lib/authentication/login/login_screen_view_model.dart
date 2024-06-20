import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_navigator.dart';
import 'package:hospital/hospital_screens/wating.dart';
import 'package:hospital/dialog_utils.dart';
import 'package:hospital/firebase_utils.dart';
import 'package:hospital/hospital_screens/home_screen_hospital.dart';
import 'package:hospital/model/my_user.dart';

import '../../methods/common_methods.dart';
import 'login_navigator.dart';

class LoginScreenViewModel extends ChangeNotifier {
  var emailController = TextEditingController(text: 'elandalusia@gmail.com');
  var passwordController = TextEditingController(text: '123456');
  CommonMethods cMethods = CommonMethods();
  static User? user;
  MyUser? userStatus;

  //todo: hold data - handle logic
  late LoginNavigator navigator;
  var formKey = GlobalKey<FormState>();

  void login(BuildContext context) async {
    if (formKey.currentState!.validate() == true) {
      navigator.showMyLoading();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        if (credential.user != null) {
          user = credential.user;
        }

        var userStatus = await FirebaseUtils.readUserFromFireStore(user!.uid);
        log(userStatus!.status.toString());
        // if(user == null){
        //   return ;
        // }
        // if (user != null) {
        //   // User is authenticated, navigate to home screen
        //   Navigator.pushReplacementNamed(context, '/home');
        // }
        // var authProvider = Provider.of<AuthProvider>(context,listen: false);
        // authProvider.updateUser(user);
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show message
        // Future<MyUser> getUserStatus(String id) async {
        //   final snapshot = await FirebaseFirestore.instance
        //       .collection("Hospitals")
        //       .where("id", isEqualTo: id)
        //       .get();
        //   final userStatus = snapshot.docs.map((e) => MyUser.fromFireStore());
        //   return userStatus;
        // }

        // navigator.showMessage('Login Successfully');
        // todo: yro7 y3ml navigate 3la el homescreen 3la tool =>>>>>>>
        if (userStatus!.status == null) {
          DialogUtils.showMessage(
              context, 'Wait for admin approval and try again',
              title: 'Log-in', posActionName: 'ok', posAction: () {
            Navigator.pushReplacementNamed(context, WaitingScreen.routeName);
          });
        } else if (userStatus!.status == true) {
          DialogUtils.showMessage(context, 'Login Successfully',
              title: 'Log-in', posActionName: 'ok', posAction: () {
            Navigator.pushReplacementNamed(
                context, HomeScreenHospital.routeName);
          });
        } else {
          DialogUtils.showMessage(context, "Sorry, you can't log to the app",
              title: 'Log-in', posActionName: 'ok', posAction: () {});
        }
        // DialogUtils.showMessage(context, 'login Successfully',
        //     title: 'Sign-Up', posActionName: 'ok', posAction: () {
        //   Navigator.pushReplacementNamed(context, HomeScreenHospital.routeName);
        //   ;
        // });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          navigator.showMessage('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          navigator.showMessage('Wrong password provided for that user.');
        } else if (e.code == 'invalid-credential') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          navigator.showMessage('Wrong password or email.');
        } else if (e.code == 'network-request-failed') {
          //todo: hide loading
          navigator.hideMyLoading();
          //todo: show message
          // navigator.showMessage('Your internet is not available. Check your connection and try again.');
          cMethods.displaySnackBar(
              'Your internet is not available. Check your connection and try again.',
              context);
        }
        // print('this error is due to authentication ${e.code}');
      } catch (e) {
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show message
        navigator.showMessage(e.toString());
        // print('this error is due to unknown $e');
      }
    }
  }

  void _listenToUserStatusChanges(BuildContext context, String userId) {
    FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final userStatus = data['status'] as bool?;
        if (userStatus == true) {
          Navigator.pushReplacementNamed(context, HomeScreenHospital.routeName);
        }
      }
    });
  }
}
