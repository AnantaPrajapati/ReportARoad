import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:reportaroad/main.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SettingPage extends StatefulWidget {
  const SettingPage({Key? key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String firstname = '';
   String lastname = '';
    String username = '';
     String email = '';
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController(); // Add controller for image
  final double horizontalPadding = 40;
  late SharedPreferences prefs;
  bool _isNotValidate = false;
bool _isNotificationEnabled = false;

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings App Bar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2C75FF),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // User Profile
          UserAccountsDrawerHeader(
            accountName: Text("$firstname $lastname"),
            accountEmail: Text(username),
            currentAccountPicture: CircleAvatar(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : "",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          // Notification and FAQ Buttons
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Toggle Button
                Row(
                  children: [
                    Text('Notifications'),
                    Switch(
                      value: false, // Set initial value based on user preference
                      onChanged: (value) {
                        // Update notification preference here
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10), // Add some space between buttons
                // FAQ Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to FAQ page
                  },
                  child: Text('FAQ'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}