import 'package:ambulance/authentication/login/login_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../methods/common_methods.dart';

class LoginScreenViewModel extends ChangeNotifier {
  var emailController = TextEditingController(text: 'ahmed.mohamed7@gmail.com');
  var passwordController = TextEditingController(text: '123456');
  CommonMethods cMethods = CommonMethods();

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

        // var user = await FirebaseUtils.readUserFromFireStore(credential.user?.uid??"");
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
        navigator.showMessage('Login Successfully');
        // todo: yro7 y3ml navigate 3la el homescreen 3la tool =>>>>>>>
        // Navigator.pushReplacementNamed(context, ScreenSelection.routeName);
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
}
