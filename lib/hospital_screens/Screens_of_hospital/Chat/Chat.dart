import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hospital/authentication/login/login_screen_view_model.dart';
import 'package:hospital/firebase_utils.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/chat_profile_widget.dart';
import 'package:hospital/model/chat_model.dart';
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
  var snapshots = FirebaseFirestore.instance
      .collection("Hospitals")
      .withConverter(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
          toFirestore: (user, options) => user.toFireStore())
      .snapshots();
  return StreamBuilder(
    stream: snapshots,
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
              return ChatTile(
                  user: user,
                  onTap: () async {
                    final chatExists = await checkChatExists(
                        LoginScreenViewModel.user!.uid, user.id!);
                    if (!chatExists) {
                      await createNewChat(
                          LoginScreenViewModel.user!.uid, user.id!);
                    }
                    //02:56 -- 41 00
                  });
            });
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}

Future<bool> checkChatExists(String uid1, String uid2) async {
  var snapshots = FirebaseFirestore.instance
      .collection(Chat.collectionName)
      .withConverter(
          fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
          toFirestore: (chat, _) => chat.toJson());

  String chatID = generateChatID(uid1: uid1, uid2: uid2);
  final result = await snapshots?.doc(chatID).get();
  if (result != null) {
    return result.exists;
  }
  return false;
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("", (id, uid) => "$id$uid");
  return chatID;
}

Future<void> createNewChat(String uid1, String uid2) async {
  String chatID = generateChatID(uid1: uid1, uid2: uid2);
  var snapshots = FirebaseFirestore.instance
      .collection(Chat.collectionName)
      .withConverter(
          fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
          toFirestore: (chat, _) => chat.toJson());
  final docRef = snapshots.doc(chatID);
  final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);
  await docRef.set(chat);
}
