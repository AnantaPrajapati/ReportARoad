import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reportaroad/main.dart';
import 'package:reportaroad/pages/UpdatedReport.dart';
import 'package:reportaroad/pages/home.dart';
import 'package:reportaroad/userAuthentication/forgetPass.dart';
import 'package:reportaroad/userAuthentication/signuppage.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isSecuredPassword = true;
  late SharedPreferences prefs;
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;

  String token = '';
  // void checkLoggedIn() {
  //   final token = prefs.getString('token');
  //   if (token != null) {
  //     // If token exists, navigate directly to Home
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => Home(token: null, id: '',)),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initSharedPref();

    // checkLoggedIn();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    initToken();
  }

  void initToken() {
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  void loginuser() async {
    setState(() {
      _isEmailEmpty = emailController.text.isEmpty;
      _isPasswordEmpty = passwordController.text.isEmpty;
    });
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        _isEmailEmpty = false;
        _isPasswordEmpty = false;
      });
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse('${serverBaseUrl}login'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(reqBody));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (jsonResponse['status']) {
          var myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
          token = myToken;
          //email=jwtDecodedToken["email"];
          String id = jwtDecodedToken["_id"];
          //  DecodedToken = jwtDecodedToken;

          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(token: myToken, id: id,)),
          );
        }
      } else {
        var errorMessage = jsonDecode(response.body)['error'];
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
            "Log-in",
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
                    border: Border.all(
                        color: _isEmailEmpty ? Colors.red : Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                        ),
                      ),
                      // if (_isEmailEmpty)
                      //   Text(
                      //     "Email field cannot be empty",
                      //     style: TextStyle(
                      //       color: Colors.red,
                      //       fontSize: 12.0,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _isPasswordEmpty ? Colors.red : Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _isSecuredPassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      // labelText: "Password",
                      border: InputBorder.none,
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
                    onPrimary: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    loginuser();
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signuppage()),
                        );
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(
                          color: Color(0xFF2C75FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPass()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Color(0xFF2C75FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
}
