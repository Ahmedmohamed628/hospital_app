// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
//
// class PushNotificationSystem {
//   FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;
//
//   Future<String?> generateDeviceRegistrationToken() async {
//     String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();
//
//     DatabaseReference referenceOnlineDriver = FirebaseDatabase.instance
//         .ref()
//         .child("Hospital")
//         .child(FirebaseAuth.instance.currentUser!.uid)
//         .child("deviceToken");
//
//     referenceOnlineDriver.set(deviceRecognitionToken);
//
//     firebaseCloudMessaging.subscribeToTopic("Hospital");
//     firebaseCloudMessaging.subscribeToTopic("users");
//   }
//
//   startListeningForNewNotification(BuildContext context) async {
//     ///1. Terminated
//     //When the app is completely closed and it receives a push notification
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? messageRemote) {
//       if (messageRemote != null) {
//         String tripID = messageRemote.data["tripID"];
//
//         // retrieveTripRequestInfo(tripID, context);
//       }
//     });
//
//     ///2. Foreground
//     //When the app is open and it receives a push notification
//     FirebaseMessaging.onMessage.listen((RemoteMessage? messageRemote) {
//       if (messageRemote != null) {
//         String tripID = messageRemote.data["tripID"];
//
//         // retrieveTripRequestInfo(tripID, context);
//       }
//     });
//
//     ///3. Background
//     //When the app is in the background and it receives a push notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? messageRemote) {
//       if (messageRemote != null) {
//         String tripID = messageRemote.data["tripID"];
//
//         // retrieveTripRequestInfo(tripID, context);
//       }
//     });
//   }
// }
