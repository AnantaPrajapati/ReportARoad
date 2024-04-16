import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.username,
  });
  final String firstname, lastname, username;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(0xFF2C75FF),
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        firstname,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        username,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}