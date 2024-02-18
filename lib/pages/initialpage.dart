import 'package:flutter/material.dart';
import 'package:reportaroad/pages/loginpage.dart';
import 'package:reportaroad/pages/signuppage.dart';
class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

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
              maxWidth: 400, // Set the maximum width
              maxHeight: 500, // Set the maximum height
            ),
            child: Image.asset(
              "assets/images/initial.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 250.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
            child: Column(
              children: [
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    "Sign-up",
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
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  Signuppage()),
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    "Log-in",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  Loginpage()),
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                //   Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Don't have an account? ",
                //       style: TextStyle(
                //         color: Colors.black,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => const Signuppage()),
                //         );
                //       },
                //       child: const Text(
                //         "Signup",
                //         style: TextStyle(
                //           color: Color(0xFF2C75FF),
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
