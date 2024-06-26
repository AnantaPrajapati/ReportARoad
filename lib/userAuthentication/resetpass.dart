import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reportaroad/main.dart';
import 'package:reportaroad/pages/NotificationService.dart';
import 'package:reportaroad/pages/PushNotification.dart';
import 'package:reportaroad/userAuthentication/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPass extends StatefulWidget {
  final String verEmail;
  const ResetPass({super.key,
  required this.verEmail});
  @override
  // ignore: library_private_types_in_public_api
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final NotificationService service = NotificationService();
  bool _isNotValidate = false;
  bool _isSecuredPassword = true;
   bool _isSecuredCPassword = true;
  
  void resetpass() async {
    if ( passwordController.text.isNotEmpty &&
     confirmpasswordController.text.isNotEmpty) {
      var reqBody = {
        "email": widget.verEmail,
        "password": passwordController.text,
      "Cpassword": confirmpasswordController.text
      };

      var response = await http.post(Uri.parse('${serverBaseUrl}resetPassword'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(reqBody));

   
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('successful'),
            content: Text("Password changed successfully"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      } else {
  
        var errorMessage =
            jsonDecode(response.body)['error']; 
        // ignore: use_build_context_synchronously
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
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 200, 
              maxHeight: 200, 
            ),
            child: Image.asset(
              "assets/images/login.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          const Text(
            "Reset Password",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: "Create Password",
                      border: InputBorder
                          .none, 
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                      // suffixIcon: toogleCPassword(),                   
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: confirmpasswordController,
                    obscureText: _isSecuredPassword,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      // labelText: "Password",
                      border: InputBorder
                          .none, 
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20.0),
                      suffixIcon: tooglePassword(),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: const Color(0xFF2C75FF),
                    // ignore: deprecated_member_use
                    onPrimary: Colors.white, // text color
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    resetpass();
                    service.createNotification(widget.verEmail,
                        "Your Password is recently changed", "", false);
                    await LocalNotifications.init();
                    LocalNotifications.showSimpleNotification(
                      title: 'Your Password is recently changed',
                      body:
                      'Please check your account',
                      payload: 'Payload from Another Page',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tooglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecuredPassword = !_isSecuredPassword;
          });
        },
        icon: _isSecuredPassword
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off),
        color: Colors.grey);
  }
   Widget toogleCPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecuredCPassword = !_isSecuredCPassword;
          });
        },
        icon: _isSecuredCPassword
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off),
        color: Colors.grey);
  }
}
