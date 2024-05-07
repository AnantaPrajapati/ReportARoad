import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reportaroad/main.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;
import 'package:reportaroad/models/location.dart';

class IncidentWarning extends StatefulWidget {
  final String userId;
  final token;

  IncidentWarning({
    Key? key,
    required this.userId,
    required this.token,
  }) : super(key: key);

  @override
  _IncidentWarningState createState() => _IncidentWarningState();
}

class _IncidentWarningState extends State<IncidentWarning> {
  List<dynamic> _report = [];
  final double incidentLatitude = 27.7120933;
  final double incidentLongitude = 85.330765;
  final double alertRadius = 5.0;

  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    // _getReport(widget.userId);
  }

  // void _getReportWithLocation() {
  //   if (userLatitude != null && userLongitude != null) {
  //     _getReport(
  //         widget.userId,
  //         Location(
  //           userLatitude!,
  //           userLongitude!,
  //         ));
  //   }
  // }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    double dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
    double dLon = (lon2 - lon1) * (3.141592653589793 / 180.0);
    double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(lat1 * (3.141592653589793 / 180.0)) *
            math.cos(lat2 * (3.141592653589793 / 180.0)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = R * c;
    return distance;
  }

  // Function to check if the user is within the alert radius of the incident location
//   void _checkAlert(double userLat, double userLon) {
//   for (Report report in _reports) {
//     double distance = _calculateDistance(report.latitude, report.longitude, userLat, userLon);
//     if (distance <= alertRadius) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Incident Alert"),
//             content: Text("You are within ${alertRadius}km of a reported incident."),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("Close"),
//               ),
//             ],
//           );
//         },
//       );
//       break;
//     }
//   }
// }

  void shareReport(String report) async {
    try {
      await Share.share(
        report,
        subject: 'Share Report',
      );
    } catch (e) {
      print('Error sharing report: $e');
    }
  }

  void _getReport(double userLatitude, double userLongitude) async {
    try {
      var response = await http.get(
        Uri.parse('${serverBaseUrl}getAllIncidentReport').replace(queryParameters: {'latitude': userLatitude.toString(), 'longitude': userLongitude.toString()}),
        headers: {
          "Content-type": "application/json",
          "Cache-Control": "no-cache"
        },
      );

      var jsonResponse = jsonDecode(response.body);
      setState(() {
        _report.clear();
      });

      // Iterate through fetched reports and filter those within the user's radius
      for (var report in jsonResponse['success']) {
        String location = report['location'];
        RegExp regex = RegExp(r'\(([^,]+),\s*([^)]+)\)');
        RegExpMatch? match = regex.firstMatch(location);
        if (match != null) {
          double reportLatitude = double.parse(match.group(1)!);
          double reportLongitude = double.parse(match.group(2)!);

          // Calculate distance between user and report location
          double distance = _calculateDistance(
            userLatitude,
            userLongitude,
            reportLatitude,
            reportLongitude,
          );

          // If the distance is within the alert radius, add the report to the list
          if (distance <= alertRadius) {
            setState(() {
              _report.add(report);
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  void deleteReport(id) async {
    try {
      print('Deleting report with ID: $id');
      var regBody = {
        "id": id,
      };
      var response = await http.post(
        Uri.parse('${serverBaseUrl}deleteReport'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        setState(() {
          _report.removeWhere((report) => report['_id'] == id);
        });
      }
    } catch (e) {
      print('Error deleting report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //        child: ListView.builder(
          // itemCount: 6,
          // itemBuilder: (context, index) {
          //   if (index == 0) {

          //     return Text(
          //       'Incident Warning Content',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     );
          //   } else {
          //     return ListTile(
          //       title: Text('Item $index'),
          //     );
          //   }
          // },

          Location(
            onLocationSelected: (latitude, longitude) {
              double userLatitude = double.parse(latitude);
              double userLongitude = double.parse(longitude);
              _getReport(userLatitude, userLongitude);
              // _getReportWithLocation();
              // _calculateDistanceAndCheckAlert();
            },
          ),

          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _report.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _report.length,
                        itemBuilder: (context, int index) {
                          return Slidable(
                            key: Key(_report[index]['_id']),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                onDismissed: () {
                                  String reportId = _report[index]['_id'];
                                  if (_report.isNotEmpty) {
                                    deleteReport(reportId);
                                  }
                                },
                              ),
                              children: [
                                SlidableAction(
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (BuildContext context) {
                                    print('${_report[index]['_id']}');
                                  },
                                ),
                              ],
                            ),
                            child: Card(
                              color: Colors.grey[50],
                              elevation: 3,
                              borderOnForeground: false,
                              child: ListTile(
                                leading: _report[index]['image'] != null
                                    ? GestureDetector(
                                        onTap: () {
                                          _showImageDialog(
                                              context, _report[index]['image']);
                                        },
                                        child: Hero(
                                          tag: 'imageHero$index',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              _report[index]['image'],
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Icon(Icons.task),
                                title: Text('${_report[index]['severity']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${_report[index]['desc']}'),
                                    Text(
                                      'Status: ${_report[index]['status'] ?? 'pending'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            (_report[index]['status'] == null ||
                                                    _report[index]['status'] ==
                                                        'pending')
                                                ? Colors.orange
                                                : (_report[index]['status'] ==
                                                        'approved')
                                                    ? Colors.green
                                                    : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        shareReport(
                                            '${_report[index]['severity']}: ${_report[index]['desc']}');
                                      },
                                    ),
                                    Icon(Icons.arrow_back),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.24,
              height: MediaQuery.of(context).size.height * 0.24,
              child: Hero(
                tag: 'imageHero',
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
