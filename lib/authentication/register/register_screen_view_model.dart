import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_screen.dart';
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
  var emailController = TextEditingController(text: 'ahmed.mohamed7@gmail.com');
  var passwordController = TextEditingController(text: '123456');
  var nameController = TextEditingController(text: 'ahmed');
  var phoneNumber = TextEditingController(text: '01228384694');
  var address = TextEditingController(text: 'alexandria');
  // todo: da le el hospital
  var doctorId = TextEditingController(text: '99');
  var doctorName = TextEditingController(text: 'Mohammed');
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
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
