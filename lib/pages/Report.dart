import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportaroad/utils/userlocation.dart';

import '../utils/order_tracking_page.dart';
import '../utils/map.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final locationController = TextEditingController();
  final severityController = TextEditingController();
  final descController = TextEditingController();
  final imageController = TextEditingController(); // Add controller for image
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  XFile? _imageFile;
Future<void> _getImageFromCamera() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);
  setState(() {
    _imageFile = image;
    if (_imageFile != null) {
      // Convert image to base64
      _convertImageToBase64();
    }
  });
}

Future<void> _convertImageToBase64() async {
  if (_imageFile != null) {
    List<int> imageBytes = await _imageFile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    setState(() {
      imageController.text = base64Image;
    });
  }
}


  void submitReport() {
    String location = locationController.text;
    String severity = severityController.text;
    String desc = descController.text;
    String imagePath = imageController.text; // Get image path from controller
    bool _isNotValidate = false;

    // You can implement your submission logic here
  }

  Future<void> submit() async {
    if (locationController.text.isNotEmpty &&
        severityController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        imageController.text.isNotEmpty) { // Check if image path is not empty
      var regBody = {
        "location": locationController.text,
        "severity": severityController.text,
        "desc": descController.text,
        "image": imageController.text, // Include image path in request body
      };

      var response = await http.post(
        Uri.parse('http://192.168.0.103:3000/report'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (jsonResponse['status']) {
          // Navigator.push(
          //   // context,
          //   // MaterialPageRoute(builder: (context) => Verify(verEmail: emailController.text)),
          // );
        }
      } else {
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
        // _isNotValidate = true;
      });
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: const Color(0xFF2C75FF),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                   Userlocationpage(), 
                  //  
                  // OrderTrackingPage(), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: locationController,
                          decoration: InputDecoration(
                            hintText: 'Enter location',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Severity',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: severityController,
                          decoration: InputDecoration(
                            hintText: 'Enter severity',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: descController,
                          decoration: InputDecoration(
                            hintText: 'Enter description',
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            _getImageFromCamera();
                          },
                          child: const Text(
                            "Attach image",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF2C75FF),
                            onPrimary: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Text form field to hold the base64 encoded image
                        TextFormField(
                          controller: imageController,
                          decoration: InputDecoration(
                            labelText: 'Image',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          readOnly: true,
                        ),
                        // SizedBox(height: 20),
                        // ElevatedButton(
                        //   onPressed: () {
      
                        //     String imageData = imageController.text;
                      
                        //     print('Sending image data to server: $imageData');
                        //   },
                        //   child: const Text(
                        //     "Send to server",
                        //     style: TextStyle(fontSize: 16),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //     primary: const Color(0xFF2C75FF),
                        //     onPrimary: Colors.white,
                        //     minimumSize: const Size(double.infinity, 50),
                        //   ),
                        // ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            submit();
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
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}