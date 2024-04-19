import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reportaroad/main.dart';
import 'package:http/http.dart' as http;

class SlideMenu extends StatefulWidget {
  String id;
  // final String firstName;
  // final String lastName;
  // final String userName;
  // final String email;

   SlideMenu({
    Key? key,
    // required this.firstName,
    // required this.lastName,
    // required this.userName,
    // required this.email,
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

  @override
void initState(){
  super.initState();
  profile();
}

  void profile() async {
    var response = await http.get(Uri.parse('${serverBaseUrl}profile/${widget.id}'),
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
            onTap: () => null,
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
                  )),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.password),
            title: Text("Change Password"),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}
