import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reportaroad/main.dart';
import 'package:reportaroad/pages/ViewReport.dart';
import 'package:reportaroad/utils/userlocation.dart';
import '../utils/SeverityDropdown.dart';
import '../utils/ImageSelection.dart';
import '../utils/map.dart';

class Report extends StatefulWidget {
  // final String email;
  final String userId;
  Report({super.key, required this.userId});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final locationController = TextEditingController();
  final severityController = TextEditingController();
  final descController = TextEditingController();
  String? imageUrl;
  bool _isNotValidate = false;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  GoogleMapController? mapController;

  // XFile? _imageFile;
  // Future<void> _getImageFromCamera() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _imageFile = image;
  //     if (_imageFile != null) {
  //       // Convert image to base64
  //       _convertImageToBase64();
  //     }
  //   });
  // }

  // Future<void> _convertImageToBase64() async {
  //   if (_imageFile != null) {
  //     List<int> imageBytes = await _imageFile!.readAsBytes();
  //     String base64Image = base64Encode(imageBytes);
  //     setState(() {
  //       imageController.text = base64Image;
  //     });
  //   }
  // }

  void setLocation(String address, String latitude, String longitude) {
    setState(() {
      locationController.text = '$address($latitude, $longitude)';
    });
  }

  void submit() async {
    if (locationController.text.isNotEmpty &&
        severityController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        imageUrl != null) {
      var reqBody = {
        "userId": widget.userId,
        "location": locationController.text,
        "severity": severityController.text,
        "desc": descController.text,
        "image": imageUrl!,
      };

      var response = await http.post(Uri.parse('${serverBaseUrl}report'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(reqBody));

      if (response.statusCode == 200) {
        locationController.clear();
        severityController.clear();
        descController.clear();
        ViewReports(userId:userId,token: token,);
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['success'] != null && jsonResponse['success']) {
            // Navigate to the verification page
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => VerifyPass(verEmail: emailController.text),
            //   ),
            // );
          }
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
                  vertical: 20,
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Container(
                        height: 400,
                        width: double.infinity,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragUpdate: (_) {},
                          child: Map(mapController: mapController),
                        ),
                      ),
                    ),
                    Userlocationpage(
                        onLocationSelected: (address, latitude, longitude) {
                      setLocation(address, latitude, longitude);
                    }),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SeverityDropdown(
                            onChanged: (newValue) {
                              severityController.text = newValue;
                            },
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: descController,
                            decoration: InputDecoration(
                              hintText: 'Enter description',
                            ),
                            maxLines: 2,
                          ),

                          SizedBox(height: 20),
                          ImageSelectionFormField(
                            onImageUploaded: (imageUrl) {
                              setState(() {
                                this.imageUrl = imageUrl;
                              });
                            },
                          ),
                          //anantaprajapati0@gmail.com
                          

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
