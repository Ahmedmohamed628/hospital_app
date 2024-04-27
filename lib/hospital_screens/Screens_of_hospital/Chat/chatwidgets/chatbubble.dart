import 'package:flutter/material.dart';
import 'package:hospital/theme/theme.dart';

class chatBubble extends StatelessWidget {
  const chatBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: MyTheme.messageColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Text("working working working working working",
            style: TextStyle(color: MyTheme.whiteColor)),
      ),
    );
  }
}
