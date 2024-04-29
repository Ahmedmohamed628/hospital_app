import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_screen_view_model.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/Chat.dart';
import 'package:hospital/model/chat_model.dart';
import 'package:hospital/model/message_model.dart';
import 'package:hospital/model/my_user.dart';
import 'package:hospital/theme/theme.dart';

class PrivateChat extends StatefulWidget {
  static const String routeName = 'Private-screen-hospital';

  final MyUser chatuser;
  const PrivateChat({
    super.key,
    required this.chatuser,
  });

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  ChatUser? currentUser, otherUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = ChatUser(
      id: LoginScreenViewModel.user!.uid,
      firstName: LoginScreenViewModel.user!.displayName,
    );
    otherUser = ChatUser(
        id: widget.chatuser.id!,
        firstName: widget.chatuser.hospitalName,
        profileImage: null); //put profile picture later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.chatuser.hospitalName!,
                style: TextStyle(color: MyTheme.whiteColor)),
            centerTitle: true,
            backgroundColor: MyTheme.redColor),
        body: StreamBuilder(
            stream: getChatData(currentUser!.id, otherUser!.id),
            builder: (context, snapshot) {
              Chat? chat = snapshot.data?.data();
              List<ChatMessage> messages = [];
              if (chat != null && chat.messages != null) {
                messages = generateChatMessagesList(chat.messages!);
              }
              ;
              return DashChat(
                  messageOptions: const MessageOptions(
                    showOtherUsersAvatar: true,
                    showTime: true,
                  ),
                  inputOptions: const InputOptions(
                    alwaysShowSend: true,
                  ),
                  currentUser: currentUser!,
                  onSend: sendmessage,
                  messages: messages);
            }));
  }

  Future<void> sendmessage(ChatMessage chatMessage) async {
    Message message = Message(
      senderID: currentUser!.id,
      content: chatMessage.text,
      messageType: MessageType.Text,
      sentAt: Timestamp.fromDate(chatMessage.createdAt),
    );
    await sendChaMessage(currentUser!.id, otherUser!.id, message);
  }

  List<ChatMessage> generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      return ChatMessage(
        user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
        text: m.content!,
        createdAt: m.sentAt!.toDate(),
      );
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }
}
