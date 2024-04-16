import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController(); // Add controller for image
  final double horizontalPadding = 40;

//   void loginuser() async {
//   if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
//     var reqBody = {
//       "email": emailController.text,
//       "password": passwordController.text
//     };

//     var response = await http.post(Uri.parse('http://192.168.0.103:3000/profile'),
//         headers: {"Content-type": "application/json"},
//         body: jsonEncode(reqBody));

//     if (response.statusCode == 200) {
//       var jsonResponse = jsonDecode(response.body);
//       print(jsonResponse['status']);

//       if (jsonResponse['status']) {
//         var myToken = jsonResponse['token'];
//         prefs.setString('token', myToken);

//         // Retrieve user information
//         var firstname = jsonResponse['firstname'];
//         var lastname = jsonResponse['lastname'];
//         var username = jsonResponse['username'];

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Home(
//             token: myToken,
//             firstname: firstname,
//             lastname: lastname,
//             username: username,
//           )),
//         );
//       }
//     } else {
//       // Handle error response from the server
//       var errorMessage =
//           jsonDecode(response.body)['error']; // Extract error message
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: Text(errorMessage),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   } else {
//     setState(() {
//       _isNotValidate = true;
//     });
//   }
// }


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
