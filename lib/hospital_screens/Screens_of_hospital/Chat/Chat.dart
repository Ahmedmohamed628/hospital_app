import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/chatwidgets/chatbubble.dart';
import 'package:hospital/model/my_user.dart';
import 'package:hospital/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreenHospital extends StatelessWidget {
  static const String routeName = 'Chat-screen-hospital';
  static const String kmessageCollection = 'messages';
  static const String kmessage = 'message';

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kmessageCollection);
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<QuerySnapshot>(
    //   future: messages.get(),
    return FutureBuilder<QuerySnapshot>(
      future: messages.get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(
              Message.fromJson(snapshot.data!.docs[i]),
            );
          }
          print(snapshot.data!.docs[0]['message']);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: MyTheme.redColor,
              title: Text('Chat', style: TextStyle(color: MyTheme.whiteColor)),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return chatBubble();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: messageController,
                    onSubmitted: (data) {
                      messages.add(
                        {
                          'message': data,
                        },
                      );
                      messageController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "send message",
                      suffixIcon: Icon(
                        Icons.send,
                        color: MyTheme.mobileChatBoxColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: MyTheme.mobileChatBoxColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: MyTheme.mobileChatBoxColor, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text("loading...");
        }
      },
    );
  }
}
