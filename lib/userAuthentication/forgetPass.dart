import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reportaroad/userAuthentication/verifypass.dart';


class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  TextEditingController emailController = TextEditingController();
  bool _isNotValidate = false;

 
    void forgetPassword() async {
    if (emailController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
      };

      var response = await http.post(
        Uri.parse('http://192.168.0.103:3000/forgetPassword'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] != null && jsonResponse['success']) {
          // Navigate to the verification page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPass(verEmail: emailController.text),
            ),
          );
        }
      } else {
        // Handle error response from the server
        var errorMessage =
            jsonDecode(response.body)['error']; // Extract error message
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
              maxWidth: 200, // Set the maximum width
              maxHeight: 200, // Set the maximum height
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
            "Please enter your e-mail",
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
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder
                          .none, // Remove the default border of TextFormField
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0),
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
                    primary: const Color(0xFF2C75FF), // BUTTON COLOR
                    // ignore: deprecated_member_use
                    onPrimary: Colors.white, // text color
                    minimumSize: const Size(double.infinity, 50), // button size
                  ),
                  onPressed: () {
                    forgetPassword();
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),    
                 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
