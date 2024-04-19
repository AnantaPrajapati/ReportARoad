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

  void profile() async {
  if (emailController.text.isNotEmpty && firstnameController.text.isNotEmpty) {
    var reqBody = {
      "email": emailController.text,
      "firstname": firstnameController.text,
            "username": usernameController.text,
                  "lastname": lastnameController.text
    };

     var response = await http.get(Uri.parse('${serverBaseUrl}profile'),
          headers: {"Content-type": "application/json"});
        

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse['status']);

      setState(() {
        firstname = jsonResponse["firstName"];
        lastname = jsonResponse["lastName"];
        username = jsonResponse["Username"];
        email = jsonResponse["Email"];

      });

    } else {
      // Handle error response from the server
      var errorMessage =
          jsonDecode(response.body)['error']; 
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } else {
    setState(() {
      _isNotValidate = true;
    });
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2C75FF),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    const Text(
                      'Firstname',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      controller: firstnameController,
                      enabled: false, // Set enabled to false to disable editing
                      decoration: const InputDecoration(),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Lastname',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: lastnameController,
                      enabled: false, // Set enabled to false to disable editing
                      decoration: InputDecoration(),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Username',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: usernameController,
                      enabled: false, // Set enabled to false to disable editing
                      decoration: InputDecoration(),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: emailController,
                      enabled: false, // Set enabled to false to disable editing
                      decoration: InputDecoration(),
                    ),
                    SizedBox(height: 20.0),
                    
                    ElevatedButton(
                      onPressed: () {
                        profile();
                        
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF2C75FF),
                        onPrimary: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
