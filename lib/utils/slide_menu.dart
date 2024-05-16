import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reportaroad/main.dart';
import 'package:http/http.dart' as http;
import 'package:reportaroad/pages/ReportHistory.dart';
import 'package:reportaroad/userAuthentication/loginpage.dart';
import 'package:reportaroad/utils/ImageSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideMenu extends StatefulWidget {
  final String userId;
  final String email;
  String id;

  SlideMenu({Key? key, required this.id, required this.userId, required this.email})
      : super(key: key);

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  String firstname = '';
  String lastname = '';
  String username = '';
  String email = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController  oldpasswordController = TextEditingController();
  TextEditingController  newpasswordController = TextEditingController();
    TextEditingController  emailController = TextEditingController();
  bool _isNotValidate = false;
  String? imageUrl;
  bool isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    profile();
  }

  void profile() async {
    var response = await http.get(
        Uri.parse('${serverBaseUrl}profile?userId=${widget.userId}'),
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
      var errorMessage = jsonDecode(response.body)['error'];
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
  }

  void updateProfile() async {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      var regBody = {
        // "email": widget.verEmail,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "username": usernameController.text
      };

      var response = await http.post(
          Uri.parse('${serverBaseUrl}updateProfile?userId=${widget.userId}'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        firstNameController.clear();
        lastNameController.clear();
        usernameController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[200],
              title: Text(''),
              content: Text("Profile Changed successfully!!!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      backgroundColor: Color(0xFF2C75FF),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (jsonResponse['status'] != null && jsonResponse['status']) {
          Navigator.pop(context);
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

 void DeleteAccount() async {
    if (emailController.text.isNotEmpty ) {
      var regBody = {
        // "email": widget.verEmail,
        "email": emailController.text
      };

      var response = await http.post(
          Uri.parse('${serverBaseUrl}DeleteAccount?userId=${widget.userId}'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        emailController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[200],
              title: Text(''),
              content: Text("User Deleted successfully!!!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                   color: Color(0xFF2C75FF),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] = true) {
          Navigator.pop(context);
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Loginpage()),
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

void changePassword() async {
    if (oldpasswordController.text.isNotEmpty &&
        newpasswordController.text.isNotEmpty 
       ) {
      var regBody = {
        // "email": widget.verEmail,
        "password": oldpasswordController.text,
        "Cpassword": newpasswordController.text,
      };

      var response = await http.post(
          Uri.parse('${serverBaseUrl}ChangePassword?email=${widget.email}'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        oldpasswordController.clear();
        newpasswordController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[200],
              title: Text(''),
              content: Text("Password Changed successfully!!!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF2C75FF),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (jsonResponse['status'] != null && jsonResponse['status']) {
          Navigator.pop(context);
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("$firstname $lastname"),
            accountEmail: Text(username),
            currentAccountPicture: CircleAvatar(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : "",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF2C75FF),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[200],
                  title: Text("Edit Profile"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                    ],
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonTheme(
                          minWidth: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              updateProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 13, 76, 211),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Column(
          //   children: [
          //     Divider(),
          //     ListTile(
          //       leading: Icon(Icons.upload),
          //       title: Text("Upload photo"),
          //       onTap: () async {
          //         String? imageUrl = await showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return ImageSelectionFormField(
          //               onImageUploaded: (imageUrl) {},
          //             );
          //           },
          //         );
          //         if (imageUrl != null) {
          //           setState(() {
          //             this.imageUrl = imageUrl;
          //           });
          //         }
          //       },
          //     ),
          //   ],
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.password),
            title: Text("Change Password"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[300],
                  title: Text("Change Password"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: oldpasswordController,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      TextFormField(
                        controller: newpasswordController,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                      ),
                    ],
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonTheme(
                          minWidth: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              changePassword();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 13, 76, 211),
                            ),
                            child: Text(
                              'Change',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.report),
          //   title: Text("Report history"),
          //     onTap: () {
          //     Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ReportHistory(userId: widget.userId,)),
          //   );
          //     },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Delete Account"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[200],
                  title: Text("Enter your email address"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'E-mail'),
                      ),
                    ],
                  ),
                  actions: [
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonTheme(
                          minWidth: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              DeleteAccount();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 13, 76, 211),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Loginpage()),
              );
            },
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Notifications"),
                trailing: Switch(
                  value: isNotificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNotificationEnabled = value;
                     
                    });
                  },
                  activeColor: Color(0xFF2C75FF),
                ),
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text("FAQs"),
                onTap: () {
                 
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
