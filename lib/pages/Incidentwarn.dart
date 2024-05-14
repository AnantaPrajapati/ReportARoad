import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reportaroad/main.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;
import 'package:reportaroad/models/location.dart';
import 'package:url_launcher/url_launcher.dart';

class Incidentwarn extends StatefulWidget {
  final String userId;
  final token;

  Incidentwarn({
    Key? key,
    required this.userId,
    required this.token,
  }) : super(key: key);

  @override
  _IncidentWarningState createState() => _IncidentWarningState();
}

class _IncidentWarningState extends State<Incidentwarn> {
  List<dynamic> _report = [];
  final double incidentLatitude = 27.7120933;
  final double incidentLongitude = 85.330765;
  final double alertRadius = 5.0;

  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    _getReport();
    // _getReport(widget.userId);
  }

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
  void _launchMap(String location) async {
  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print('Could not launch $url');
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

  void _getReport() async {
    try {
      var response = await http.get(
        Uri.parse('${serverBaseUrl}getIncidentReport'),
        headers: {
          "Content-type": "application/json",
          "Cache-Control": "no-cache"
        },
      );

      var jsonResponse = jsonDecode(response.body);
      setState(() {
        _report = jsonResponse['success'];
        _report.forEach((report) {});
      });
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.blue,
                onPressed: () {
                  _getReport();
                },
              ),
              Text(
                'Please be aware',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _report.isEmpty
                    ? Center(child: Text('No reports available'))
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
                            child: SizedBox(
                              height: 150,
                              child: Card(
                                color: Colors.grey[50],
                                elevation: 3,
                                borderOnForeground: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: _report[index]['image'] != null
                                        ? GestureDetector(
                                            onTap: () {
                                            _showReportDetailsDialog(
                                              _report[index]);
                                            },
                                            child: Hero(
                                              tag: 'imageHero$index',
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  _report[index]['image'],
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Icon(Icons.task),
                                    title: Text(
                                      '${_report[index]['title']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        '${_report[index]['desc']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {
                                            shareReport(
                                                '${_report[index]['title']}: ${_report[index]['desc']}');
                                          },
                                        ),
                                        Icon(Icons.arrow_back),
                                      ],
                                    ),
                                  ),
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
  
  void _showImageDialog(
      BuildContext context, List<String> imageUrls, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashPattern: [4, 4],
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

void _showReportDetailsDialog(Map<String, dynamic> reportDetails) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Report Details'),
        backgroundColor: Colors.grey[200],
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reportDetails['images'] != null)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    reportDetails['images'].length,
                    (index) => GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            context, reportDetails['images'], index);
                      },
                      child: Hero(
                        tag: 'imageHero_${reportDetails['_id']}_$index',
                        child: Image.network(
                          reportDetails['images'][index],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  _launchMap(reportDetails['location']);
                },
                child: Text(
                  'Location: ${reportDetails['location']}',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Description: ${reportDetails['desc']}'),
              SizedBox(height: 10),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF2C75FF),
              ),
            ),
          ),
        ],
      );
    },
  );
}

}
