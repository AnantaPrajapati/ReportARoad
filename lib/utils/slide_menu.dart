import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reportaroad/utils/UserInfo.dart';

class SlideMenue extends StatelessWidget {
  const SlideMenue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 288,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              UserInfo(
                firstname: "Ananta",
                lastname: "Prajapati",
                username: "user",
              ),
              // Other items in the menu can be added here
            ],
          ),
        ),
      ),
    );
  }
}
