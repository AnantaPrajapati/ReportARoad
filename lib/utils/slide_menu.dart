import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reportaroad/main.dart';
import 'package:http/http.dart' as http;
import 'package:reportaroad/pages/ViewReport.dart';
import 'package:reportaroad/userAuthentication/loginpage.dart';

class SlideMenu extends StatefulWidget {
  String id;

  SlideMenu({
    Key? key,
    required this.id,
  }) : super(key: key);

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
  bool _isNotValidate = false;

  @override
  void initState() {
    super.initState();
    profile();
  }

  void profile() async {
    var response = await http.get(
        Uri.parse('${serverBaseUrl}profile/${widget.id}'),
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
          Uri.parse('${serverBaseUrl}updateProfile/${widget.id}'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        firstNameController.clear();
        lastNameController.clear();
        usernameController.clear();
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
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Edit Details"),
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
                    ElevatedButton(
                      onPressed: () {
                        updateProfile();
                      },
                      child: Text('Save'),
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
          Divider(),
          ListTile(
            leading: Icon(Icons.password),
            title: Text("Change Password"),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.report),
            title: Text("View Report"),
          //   onTap: () {
          //   Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ViewReports(userId: '',)),
          // );
          //   },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Loginpage()),
          );
            },
          ),
        ],
      ),
    );
  }
}
