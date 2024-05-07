
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reportaroad/main.dart';
import 'package:reportaroad/models/image.dart';
import 'package:reportaroad/pages/ViewReport.dart';
import 'package:reportaroad/utils/userlocation.dart';
import '../utils/SeverityDropdown.dart';
import '../utils/ImageSelection.dart';
import '../utils/map.dart';

class Report extends StatefulWidget {
  // final String email;
  final String userId;
  final token;
    final Function(int) updateReportCount; 
  Report({super.key, required this.userId, required this.token, required this.updateReportCount});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final locationController = TextEditingController();
  final severityController = TextEditingController();
  final descController = TextEditingController();
  List<String> _imageUrls = [];
  bool _isNotValidate = false;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  late String userId;
   int reportCount = 0;

  GoogleMapController? mapController;


  void setLocation(String address, String latitude, String longitude) {
    setState(() {
      locationController.text = '$address($latitude, $longitude)';
    });
  }
 
 @override
  void initState() {
    super.initState();
    // TODO: implement initState
    ViewReports(userId: widget.userId, token: widget.token,);
  }
  void submit() async {
  if (locationController.text.isNotEmpty &&
      severityController.text.isNotEmpty &&
      descController.text.isNotEmpty &&
      _imageUrls != null) {
    var reqBody = {
      "userId": widget.userId,
      "location": locationController.text,
      "severity": severityController.text,
      "desc": descController.text,
      "images": _imageUrls,
      "status": "pending", 
    };

    var response = await http.post(Uri.parse('${serverBaseUrl}report'),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(reqBody));

    if (response.statusCode == 200) {
      locationController.clear();
      severityController.clear();
      descController.clear();
      widget.updateReportCount(reportCount + 1); 
      ViewReports(userId:userId, token: token,);
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(''),
              content: Text("Report Submitted successfully"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

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
  } else {
    setState(() {
      _isNotValidate = true;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: AppBar(
            backgroundColor: Color(0xFF2C75FF),
            elevation: 5,
            title: const Text(
              "Report",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          child: Map(mapController: mapController, markers: [],),
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
                          ImageForm(
                            onImageUploaded: (List<String> imageUrls) {
                              setState(() {
                               _imageUrls = imageUrls;

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
