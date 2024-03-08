import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reportaroad/userAuthentication/resetpass.dart';


class VerifyPass extends StatefulWidget {
  final String verEmail;
  const VerifyPass({super.key,
  required this.verEmail});
  @override 
  // ignore: library_private_types_in_public_api
  _VerifyPassState createState() => _VerifyPassState();

}

class _VerifyPassState extends State<VerifyPass> {
   TextEditingController digitController = TextEditingController();
   bool _isNotValidate = false;
   
   void verifyuser() async {
  if (digitController.text.isNotEmpty) {
    var regBody = {
      "email": widget.verEmail,
      "Otp": digitController.text
    };

    var response = await http.post(
      Uri.parse('http:// 192.168.0.103:3000/verifyResetOtp'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      
      if (jsonResponse['status']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPass(verEmail: widget.verEmail)),
        );
      }
    } else {
        // Handle error response from the server
        var errorMessage =
            jsonDecode(response.body)['error']; // Extract error message
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
            height: 70.0,
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 200, // Set the maximum width
              maxHeight: 500, // Set the maximum height
            ),
            child: Image.asset(
              "assets/images/verify.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          const Text(
            "Enter Otp",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          // const Row(
          //         children: [
          //           Expanded(
          //             child: Center(
          //               child: Text(
          //                 "Don't have an account? Signup",
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
                const SizedBox(
                 height: 10.0,
                ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: digitController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    // obscureText: true, //hides the entered digits
                    // ignore: unnecessary_const
                    decoration: const InputDecoration(
                      hintText: "Enter 4-digit code",
                      counterText: "", // To hide the default character count
                      border: InputBorder.none,
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
                    "Next",
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
                    verifyuser();
                  },
                ), 
                 const SizedBox(
                  height: 20.0,
                ),
                // const Row(
                //   children: [
                //     Expanded(
                //       child: Center(
                //         child: Text(
                //           "Resend Code",
                //           style: TextStyle(
                //             color: Color(0xFF2C75FF),
                //             fontWeight: FontWeight.bold,
                //             fontSize: 15,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
