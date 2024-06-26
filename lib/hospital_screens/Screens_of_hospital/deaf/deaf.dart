import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'logic.dart';

List<CameraDescription>? cameras;

Future<void> initializeAppAndCameras() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
}

class DeafScreenHospital extends StatelessWidget {
  static const String routeName = 'deaf-screen-hospital';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  loadmodel() async {
    Tflite.loadModel(
      model: "assets/detect.tflite", //assets/detect.tflite
      labels: "assets/labels.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      //todo: lottie assets
      //Lottie.asset('assets/images/patient_lottie.json')
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            margin: EdgeInsets.all(20),
            height: 50,
            width: w,
            child: MaterialButton(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                initializeAppAndCameras;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              child: Text(
                'Start Detecting',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
