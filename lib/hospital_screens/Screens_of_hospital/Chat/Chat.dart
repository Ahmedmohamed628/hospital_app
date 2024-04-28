import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hospital/firebase_utils.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/chat_profile_widget.dart';
import 'package:hospital/model/my_user.dart';
import 'package:hospital/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class ChatScreenHospital extends StatelessWidget {
  static const String routeName = 'Chat-screen-hospital';

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<QuerySnapshot>(
    //   future: messages.get(),
    return Scaffold(
      appBar: AppBar(
        title: Text("chat"),
      ),
      body: _chatList(),
    );
  }
}

Widget _chatList() {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("Hospitals")
        .withConverter(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (user, options) => user.toFireStore())
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        log(snapshot.hasError.toString());
        return Text("no data");
      }

      if (snapshot.hasData && snapshot.data != null) {
        final users = snapshot.data!.docs;
        return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, Index) {
              MyUser user = users[Index].data();
              return ChatTile(user: user, onTap: () {});
            });
      }
      return CircularProgressIndicator();
    },
  );
}
