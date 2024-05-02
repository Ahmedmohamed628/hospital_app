import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/my_user.dart';

class ChatTile extends StatelessWidget {
  final Mypatient user;
  final Function onTap;
  const ChatTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: false,
      //fixed image just for now change it for profile one later
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.pfpURL ?? ""),
      ),
      title: Text(user.name!),
    );
  }
}
