import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/chatwidgets/chatbubble.dart';
import 'package:hospital/theme/theme.dart';

class ChatScreenHospital extends StatelessWidget {
  static const String routeName = 'Chat-screen-hospital';
  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (context, index) {
                return chatBubble();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "send message",
                suffixIcon: Icon(
                  Icons.send,
                  color: MyTheme.mobileChatBoxColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: MyTheme.mobileChatBoxColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: MyTheme.mobileChatBoxColor, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
