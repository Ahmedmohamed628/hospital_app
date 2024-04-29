import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital/authentication/login/login_screen_view_model.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/Chat.dart';
import 'package:hospital/model/chat_model.dart';
import 'package:hospital/model/message_model.dart';
import 'package:hospital/model/my_user.dart';
import 'package:hospital/theme/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

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
                  inputOptions: InputOptions(alwaysShowSend: true, trailing: [
                    _mediaMessageButton(),
                  ]),
                  currentUser: currentUser!,
                  onSend: sendmessage,
                  messages: messages);
            }));
  }

  Future<void> sendmessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
            senderID: chatMessage.user.id,
            content: chatMessage.medias!.first.url,
            messageType: MessageType.Image,
            sentAt: Timestamp.fromDate(chatMessage.createdAt));
        await sendChaMessage(currentUser!.id, otherUser!.id, message);
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      await sendChaMessage(currentUser!.id, otherUser!.id, message);
    }
  }

  List<ChatMessage> generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            createdAt: m.sentAt!.toDate(),
            medias: [
              ChatMedia(url: m.content!, fileName: "", type: MediaType.image)
            ]);
      } else {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    // chatMessages.sort((a, b) {
    //   return b.createdAt.compareTo(a.createdAt);
    // });
    chatMessages = chatMessages.reversed.toList();
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
        onPressed: () async {
          File? filechat = await getImageFromGallary();
          if (filechat != null) {
            String? ImageURL = await uplaodImageToChat(
                file: filechat,
                ChatID:
                    generateChatID(uid1: currentUser!.id, uid2: otherUser!.id));
            if (ImageURL != null) {
              ChatMessage chatMessage = ChatMessage(
                  user: currentUser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                        url: ImageURL, fileName: "", type: MediaType.image)
                  ]);
              sendmessage(chatMessage);
            }
          }
        },
        icon: Icon(Icons.image));
  }

  Future<File?> getImageFromGallary() async {
    final ImagePicker picker = ImagePicker();

    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
    return null;
  }

  Future<String?> uplaodImageToChat(
      {required File file, required String ChatID}) async {
    final firebaseStorage = FirebaseStorage.instance;
    Reference fileRef = firebaseStorage
        .ref('chats/$ChatID')
        .child("${DateTime.now().toIso8601String()}${p.extension(file.path)}");
    UploadTask task = fileRef.putFile(file);
    return task.then((p0) {
      if (p0.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }
}