import 'package:ambulance/authentication/register/register_navigator.dart';
import 'package:ambulance/authentication/register/register_screen_view_model.dart';
import 'package:ambulance/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../dialog_utils.dart';
import '../component/custom_text_form_field.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register-screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    implements RegisterNavigator {
  var confirmationPasswordController = TextEditingController(text: '123456');
  RegisterScreenViewModel viewModelRegister = RegisterScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModelRegister.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title:
            Text('Ambulance App', style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/ambulance_icon.png'),
                radius: 60,
                backgroundColor: MyTheme.redColor,
              ),
            ),
            // Image.asset('assets/images/ambulance_icon.png', alignment: Alignment.topCenter),
            Form(
                key: viewModelRegister.formKey,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      // user name
                      CustomTextFormField(
                          prefixIcon: Icon(Icons.person_pin_sharp,
                              color: MyTheme.redColor),
                          //Icons.drive_file_rename_outline
                          label: 'User Name',
                          controller: viewModelRegister.nameController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please Enter User Name';
                            }
                            return null;
                          }),
                      // email
                      CustomTextFormField(
                          prefixIcon: Icon(Icons.email_rounded,
                              color: MyTheme.redColor),
                          label: 'Email address',
                          keyboardType: TextInputType.emailAddress,
                          controller: viewModelRegister.emailController,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please Enter An Email';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(text);
                            if (!emailValid) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          }),
                      // phone
                      CustomTextFormField(
                        label: 'Phone number',
                        controller: viewModelRegister.phoneNumber,
                        prefixIcon: Icon(Icons.phone, color: MyTheme.redColor),
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (text.length < 11) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      //address
                      CustomTextFormField(
                        label: 'Address',
                        controller: viewModelRegister.address,
                        prefixIcon:
                            Icon(Icons.home_filled, color: MyTheme.redColor),
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter an address';
                          }
                          // valid address???????????????????????????????????????????
                          if (text.length < 4) {
                            return 'Enter a valid address';
                          }
                          return null;
                        },
                      ),
                      //password
                      CustomTextFormField(
                        prefixIcon: Icon(Icons.lock, color: MyTheme.redColor),
                        label: 'Password',
                        keyboardType: TextInputType.number,
                        controller: viewModelRegister.passwordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter a password';
                          }
                          if (text.length < 6) {
                            return 'Password should be at least 6 characters';
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      //confirm pass
                      CustomTextFormField(
                        prefixIcon:
                            Icon(Icons.password, color: MyTheme.redColor),
                        //lock_outline_sharp
                        label: 'Confirm Password',
                        keyboardType: TextInputType.number,
                        controller: confirmationPasswordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter the Confirmation Password';
                          }
                          if (text !=
                              viewModelRegister.passwordController.text) {
                            return "password doesn't match";
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      // chronic diseases
                      CustomTextFormField(
                        prefixIcon:
                            Icon(Icons.coronavirus, color: MyTheme.redColor),
                        //lock_outline_sharp
                        label: 'Chronic Disease',
                        controller: viewModelRegister.chronicDiseases,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter a Chronic Diseases';
                          }
                          return null;
                        },
                      ),
                      //
                      CustomTextFormField(
                        prefixIcon:
                            Icon(Icons.coronavirus, color: MyTheme.redColor),
                        //lock_outline_sharp
                        label: 'Chronic Disease',
                        controller: viewModelRegister.chronicDiseases,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter a Chronic Diseases';
                          }
                          return null;
                        },
                      ),

                      // button of registration
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // cMethods.checkConnectivity(context);
                            viewModelRegister.register(context);
                          },
                          child: Text('Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.redColor,
                              padding: EdgeInsets.symmetric(vertical: 10)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already Have An Account',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                          TextButton(
                            onPressed: () {
                              // navigate to loginScreen
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: Text('Login',
                                style: TextStyle(
                                    color: MyTheme.redColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // void register() async {
  //   if (formKey.currentState?.validate() == true) {
  //     viewModelRegister.register(emailController.text, passwordController.text, context);
  //     // Navigator.pushReplacementNamed(context, ScreenSelection.routeName );
  //   }
  // }

  @override
  void hideMyLoading() {
    // TODO: implement hideMyLoading
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading() {
    // TODO: implement showMyLoading
    DialogUtils.showLoading(context, 'Loading...');
  }

  @override
  void showMessage(String message) {
    // TODO: implement showMessage
    DialogUtils.showMessage(context, message,
        posActionName: 'ok', title: 'Sign-Up', barrierDismissible: false);
  }
}
