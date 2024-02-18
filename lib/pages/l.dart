// // import 'package:flutter/material.dart';

// // class loginPage extends StatelessWidget {
// //   const loginPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Material(
// //       color: Colors.white,
// //       child: Column(
// //         children: [
// //           Image.asset(
// //             "assets/images/login.png",
// //             fit: BoxFit.cover,
// //           ),
// //           SizedBox(
// //             height: 10.0,
// //           ),
// //           Text(
// //             "Login",
// //             style: TextStyle(
// //               fontSize: 25,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           SizedBox(
// //             height: 20.0,
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
// //             child: Column(
// //               children: [
// //                 TextFormField(
// //                   decoration: InputDecoration(
// //                     hintText: "Email or Username",
// //                     labelText: "Email or Username",
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 20.0,
// //                 ),
// //                 ElevatedButton(
// //                   child: Text("Next"),
// //                   style: TextButton.styleFrom(),
// //                   onPressed: () {},
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';


// // class signuppag extends StatelessWidget {
// //   const signuppage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Placeholder();
// //   }
// // }

// // const express = require('express');
// // const mysql = require('mysql');
// // const cors = require('cors');

// // const app = express();
// // const port = 3001;

// // app.use(cors());
// // app.use(express.json());

// // // Create a MySQL connection
// // const db = mysql.createConnection({
// //   host: 'your_mysql_host',
// //   user: 'your_mysql_user',
// //   password: 'your_mysql_password',
// //   database: 'your_mysql_database',
// // });

// // // Connect to MySQL
// // db.connect((err) => {
// //   if (err) {
// //     console.log('MySQL Connection Error:', err);
// //   } else {
// //     console.log('Connected to MySQL');
// //   }
// // });

// // // API endpoint for handling login
// // app.post('/login', (req, res) => {
// //   const { emailOrUsername } = req.body;

// //   // Perform a simple query
// //   const query = `SELECT * FROM users WHERE email = ? OR username = ?`;
// //   db.query(query, [emailOrUsername, emailOrUsername], (err, results) => {
// //     if (err) {
// //       console.log('MySQL Query Error:', err);
// //       res.status(500).send('Internal Server Error');
// //     } else {
// //       // Assuming users table has fields like id, email, username
// //       if (results.length > 0) {
// //         // User found
// //         res.json({ success: true, user: results[0] });
// //       } else {
// //         // User not found
// //         res.json({ success: false, message: 'User not found' });
// //       }
// //     }
// //   });
// // });

// // app.listen(port, () => {
// //   console.log(`Server is running on port ${port}`);
// // });




// // const SizedBox(
// //                   height: 20.0,
// //                 ),
// //                     ElevatedButton(
// //                   child: const Text("login with gmail"),
// //                   style: ElevatedButton.styleFrom(
// //                     primary: const Color(0xFF2C75FF), // BUTTON COLOR
// //                     onPrimary: Colors.white, // text color
// //                     minimumSize: const Size(double.infinity, 50), // button size
// //                   ),
// //                   onPressed: () {},
// //                 ),





// //initial

// //  Expanded(
// //             child: Center(
// //               child: GestureDetector(
// //                 onTap: () {
// //                   // Navigate to the signup page when the text is tapped
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => signuppage()),
// //                   );
// //                 },
// //                 child: const Text(
// //                   "Don't have an account? Signup",
// //                   style: TextStyle(
// //                     color: Colors.blue,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),





// //loggginn
// import 'package:flutter/material.dart';
// import 'package:reportaroad/pages/signuppage.dart';
// import 'package:reportaroad/pages/verify.dart';
// import 'package:http/http.dart' as http;

// class Loginpage extends StatelessWidget {
//   const Loginpage({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 70.0,
//           ),
//           Container(
//             constraints: const BoxConstraints(
//               maxWidth: 200, // Set the maximum width
//               maxHeight: 500, // Set the maximum height
//             ),
//             child: Image.asset(
//               "assets/images/login.png",
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(
//             height: 50.0,
//           ),
//           const Text(
//             "Log-in",
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(
//             height: 20.0,
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: TextFormField(
//                     decoration: const InputDecoration(
//                       hintText: "Email or Username",
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(vertical: 20.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 ElevatedButton(
//                   // ignore: sort_child_properties_last
//                   child: const Text(
//                     "Next",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     // ignore: deprecated_member_use
//                     primary: const Color(0xFF2C75FF), // BUTTON COLOR
//                     // ignore: deprecated_member_use
//                     onPrimary: Colors.white, // text color
//                     minimumSize: const Size(double.infinity, 50), // button size
//                   ),
//                   onPressed: () {
//                     sendDataToServer(context);
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 const Row(
//                   children: [
//                     Expanded(
//                       child: Divider(
//                         thickness: 1,
//                         color: Colors.black,
//                      padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text("or"),
//                     ),
//                     Expanded(
//                       child: Divider(
//                         thickness: 1,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const signuppage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     // ignore: deprecated_member_use
//                     primary: const Color(0xFF2C75FF), // BUTTON COLOR
//                     // ignore: deprecated_member_use
//                     onPrimary: Colors.white, // text color
//                     minimumSize:
//                         const Size(double.infinity, 50), // button size
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         constraints: const BoxConstraints(
//                           maxWidth: 44, // Set the maximum width
//                           maxHeight: 44, // Set the maximum height
//                         ),
//                         child: Image.asset(
//                           "assets/images/google_logo.png",
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Text(
//                         "Continue with google",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                 ),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Don't have an account? ",
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         "Signup",
//                         style: TextStyle(
//                           color: Color(0xFF2C75FF),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void sendDataToServer(BuildContext context) async {
//     // Extract the email/username and code from the TextFormField
//     final emailOrUsername = 'example@example.com'; // Replace with your logic to get the entered email or username
//     final code = '123456'; // Replace with your logic to get the entered code

//     // Prepare the data to be sent in the request body
//     final Map<String, dynamic> postData = {
//       'emailorusername': emailOrUsername,
//       'code': code,
//     };

//     // Send the POST request to your server
//     final response = await http.post(
//       Uri.parse('http://localhost:9000/'), // Replace with your server URL
//       body: postData,
//     );

//     // Check if the request was successful
//     if (response.statusCode == 200) {
//       // Data was successfully inserted into the database
//       print('Data inserted successfully');
//     } else {
//       // Error occurred while inserting data into the database
//       print('Error inserting data: ${response.body}');
//     }

//     // Navigate to the verify page
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const verify()),
//     );
//   }
// }                     ),
//                     ),
//                     Padding(
  
