import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reportaroad/main.dart';
import 'package:share_plus/share_plus.dart';

class UpdatedReport extends StatefulWidget {
  final String userId;
  final token;

  UpdatedReport({
    Key? key,
    required this.userId,
    required this.token,
  }) : super(key: key);

  @override
  _ViewReportsState createState() => _ViewReportsState();
}

class _ViewReportsState extends State<UpdatedReport> {
  List<dynamic> _report = [];

  @override
  void initState() {
    super.initState();
    _getReport(widget.userId);
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

  void _getReport(userId) async {
    try {
      var response = await http.get(
        Uri.parse('${serverBaseUrl}getReport?userId=${widget.userId}'),
        headers: {
          "Content-type": "application/json",
          "Cache-Control": "no-cache"
        },
      );

      var jsonResponse = jsonDecode(response.body);
      setState(() {
        _report = jsonResponse['success'];
        _report.forEach((report) {
          if (report['status'] == null) {
            report['status'] = 'pending';
          }
        });
      });
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
        _getReport(widget.userId);
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
          Container(
            decoration: const BoxDecoration(
              color: const Color(0xFF2C75FF),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: Row(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.blue,
                  onPressed: () {
                    _getReport(widget.userId);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
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
                                  setState(() {
                                    _report.removeAt(index);
                                  });
                                  if (_report.isNotEmpty) {
                                    deleteReport(_report[index]['_id']);
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
                              borderOnForeground: false,
                              child: ListTile(
                                leading: _report[index]['image'] != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          _report[index]['image'],
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
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
}
