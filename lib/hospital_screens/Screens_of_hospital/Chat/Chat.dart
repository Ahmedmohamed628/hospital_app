import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/chat_profile_widget.dart';
import 'package:hospital/hospital_screens/Screens_of_hospital/Chat/private_chat.dart';
import 'package:hospital/model/chat_model.dart';
import 'package:hospital/model/message_model.dart';
import 'package:hospital/model/my_user.dart';
import 'package:hospital/theme/theme.dart';

class ChatScreenHospital extends StatelessWidget {
  static const String routeName = 'Chat-screen-hospital';

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<QuerySnapshot>(
    //   future: messages.get(),
    return Scaffold(
      appBar: AppBar(
          title: Text("Chat", style: TextStyle(color: MyTheme.whiteColor)),
          centerTitle: true,
          backgroundColor: MyTheme.redColor),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/chat_list2.jpg'),
              fit: BoxFit.cover, // Adjust as needed (cover, contain, etc.)
            ),
          ),
          child: _chatList()),
    );
  }
}

// Widget _chatList() {
//   var snapshots = FirebaseFirestore.instance
//       .collection("patients")
//       .withConverter(
//           fromFirestore: (snapshot, options) =>
//               Mypatient.fromFireStore(snapshot.data()!),
//           toFirestore: (user, options) => user.toFireStore())
//       .snapshots();
//   return StreamBuilder(
//     stream: snapshots,
//     builder: (context, snapshot) {
//       if (snapshot.hasError) {
//         return Center(child: Text("no data"));
//       }

//       if (snapshot.hasData && snapshot.data != null) {
//         final users = snapshot.data!.docs;
//         final userCurrent = FirebaseAuth.instance.currentUser;
//         return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, Index) {
//               Mypatient user = users[Index].data();
//               return ChatTile(
//                   user: user,
//                   onTap: () async {
//                     final chatExists =
//                         await checkChatExists(userCurrent!.uid, user.id!);
//                     print(chatExists);
//                     if (!chatExists) {
//                       await createNewChat(userCurrent.uid, user.id!);
//                     }
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) {
//                           return PrivateChat(
//                             chatuser: user,
//                           );
//                         },
//                       ),
//                     );
//                     //02:56 -- 41 00
//                   });
//             });
//       }
//       return Center(child: CircularProgressIndicator());
//     },
//   );
// }

//////////////////////////////////////// seen test
Widget _chatList() {
  final userCurrent = FirebaseAuth.instance.currentUser;

  var unseenMessageStream = FirebaseFirestore.instance
      .collection(Chat.collectionName)
      .withConverter<Chat>(
        fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
        toFirestore: (chat, _) => chat.toJson(),
      )
      .where('participants', arrayContains: userCurrent!.uid)
      .snapshots();

  return StreamBuilder<QuerySnapshot<Chat>>(
    stream: unseenMessageStream,
    builder: (context, chatSnapshot) {
      if (chatSnapshot.hasError) {
        return Center(child: Text("Error: ${chatSnapshot.error}"));
      }
      if (chatSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
        return Center(child: Text("No chats available"));
      }

      final chatDocs = chatSnapshot.data!.docs;
      final List<QueryDocumentSnapshot<Chat>> chats =
          chatDocs.cast<QueryDocumentSnapshot<Chat>>();

      return FutureBuilder<List<Map<String, dynamic>>>(
        future: getChatsWithUnseenCounts(chats, userCurrent.uid),
        builder: (context, unseenCountSnapshot) {
          if (unseenCountSnapshot.hasError) {
            return Center(child: Text("Error: ${unseenCountSnapshot.error}"));
          }
          if (!unseenCountSnapshot.hasData ||
              unseenCountSnapshot.data!.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final chatsWithUnseenCounts = unseenCountSnapshot.data!;
          return ListView.builder(
            itemCount: chatsWithUnseenCounts.length,
            itemBuilder: (context, index) {
              final chatData = chatsWithUnseenCounts[index];
              final Mypatient user = chatData['user'];
              final int unseenCount = chatData['unseenCount'];
              final String chatID =
                  generateChatID(uid1: userCurrent.uid, uid2: user.id!);
              return ChatTile(
                user: user,
                onTap: () async {
                  final chatExists =
                      await checkChatExists(userCurrent.uid, user.id!);
                  if (!chatExists) {
                    await createNewChat(userCurrent.uid, user.id!);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PrivateChat(
                          chatuser: user,
                        );
                      },
                    ),
                  );
                },
                unseenCount: unseenCount,
              );
            },
          );
        },
      );
    },
  );
}

Future<List<Map<String, dynamic>>> getChatsWithUnseenCounts(
    List<QueryDocumentSnapshot<Chat>> chats, String currentUid) async {
  List<Map<String, dynamic>> chatsWithUnseenCounts = [];

  for (var chatDoc in chats) {
    Chat chat = chatDoc.data();
    String otherParticipantId = chat.participants!.firstWhere(
      (uid) => uid != currentUid,
      orElse: () => "",
    );

    if (otherParticipantId.isNotEmpty) {
      var userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(otherParticipantId)
          .withConverter<Mypatient>(
            fromFirestore: (snapshot, _) =>
                Mypatient.fromFireStore(snapshot.data()!),
            toFirestore: (user, _) => user.toFireStore(),
          )
          .get();

      if (userDoc.exists) {
        Mypatient user = userDoc.data()!;
        int unseenCount =
            await getUnseenMessageCount(currentUid, otherParticipantId);
        chatsWithUnseenCounts.add({'user': user, 'unseenCount': unseenCount});
      }
    }
  }

  chatsWithUnseenCounts
      .sort((a, b) => b['unseenCount'].compareTo(a['unseenCount']));
  return chatsWithUnseenCounts;
}

Future<int> getUnseenMessageCount(String uid1, String uid2) async {
  try {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    log("Generated Chat ID: $chatID");

    var chatDocRef = FirebaseFirestore.instance
        .collection(Chat.collectionName)
        .doc(chatID)
        .withConverter<Chat>(
          fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
          toFirestore: (chat, _) => chat.toJson(),
        );

    var chatSnapshot = await chatDocRef.get();

    if (!chatSnapshot.exists) {
      log("Chat document not found");
      return 0;
    }

    Chat chat = chatSnapshot.data()!;
    int unseenCount = chat.messages!
        .where((message) => message.senderID != uid1 && !message.seen!)
        .length;

    log('Unseen count for chatID $chatID: $unseenCount');

    return unseenCount;
  } catch (e) {
    log("Failed to get unseen message count: $e");
    return 0;
  }
}
////////////////////////////////////////seen test logic

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

Future<void> sendChaMessage(String uid1, String uid2, Message message) async {
  String chatID = generateChatID(uid1: uid1, uid2: uid2);
  var snapshots = FirebaseFirestore.instance
      .collection(Chat.collectionName)
      .withConverter(
          fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
          toFirestore: (chat, _) => chat.toJson());
  final docRef = snapshots.doc(chatID);
  await docRef.update(
    {
      "messages": FieldValue.arrayUnion(
        [
          message.toJson(),
        ],
      ),
    },
  );
}

Stream getChatData(String uid1, String uid2) {
  String chatID = generateChatID(uid1: uid1, uid2: uid2);
  var snapshots = FirebaseFirestore.instance
      .collection(Chat.collectionName)
      .withConverter(
          fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
          toFirestore: (chat, _) => chat.toJson());
  return snapshots.doc(chatID).snapshots();
}
