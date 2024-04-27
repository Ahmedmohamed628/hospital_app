import 'package:flutter/material.dart';

import '../../../screens_chat/mobile_layout_screen.dart';
import '../../../screens_chat/web_layout_screen.dart';
import '../../../utils/responsive_layout.dart';

class ChatScreenHospital extends StatelessWidget {
  static const String routeName = 'Chat-screen-hospital';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Text("working"),
      ),
    ));
  }
}

//Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyTheme.redColor,
//         title: Text('Chat', style: TextStyle(color: MyTheme.whiteColor)),
//         centerTitle: true,
//       ),
//       backgroundColor: MyTheme.whiteColor,
//     );
