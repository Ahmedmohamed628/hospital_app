import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/deaf/logic.dart';
import 'package:tflite_v2/tflite_v2.dart';

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
  @override
  void initState() {
    super.initState();
    loadModel();
    initializeAppAndCameras();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/detect.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              child: Text('Start Detecting'),
            ),
          ),
        ),
      ),
    );
  }
}
