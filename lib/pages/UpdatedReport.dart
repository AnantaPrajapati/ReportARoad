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
  String rating = '';
  String feedback = '';
  TextEditingController ratingController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  bool _isNotValidate = false;

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
        Uri.parse('${serverBaseUrl}resolvedReport?userId=${widget.userId}'),
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
          if (report['rating'] == null) {
            report['rating'] = 0;
          }
          if (report['feedback'] == null) {
            report['feedback'] = '';
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
        setState(() {
          _report.removeWhere((report) => report['_id'] == id);
        });
      }
    } catch (e) {
      print('Error deleting report: $e');
    }
  }

void submitRatingAndFeedback(String reportId) async {
  if (ratingController.text.isNotEmpty && feedbackController.text.isNotEmpty) {
    var regBody = {
      "rating": ratingController.text,
      "feedback": feedbackController.text,
    };

    var response = await http.post(
      Uri.parse('${serverBaseUrl}ratingFeedback?reportId=$reportId&userId=${widget.userId}'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(regBody),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] != null && jsonResponse['success']) {
        ratingController.clear();
        feedbackController.clear();
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
      }
       else {
      var errorMessage = jsonDecode(response.body)['error'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('You have already submitted a rating and feedback for this report'),
                ),
              ],
            );
          },
        );
      }
    } 
    // else {
    //   var errorMessage = 'An error occurred';
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Error'),
    //         content: Text(errorMessage),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  } else {
    setState(() {
      _isNotValidate = true;
    });
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
                                      'Status: ${_report[index]['status'] ?? 'resolved'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _report[index]['status'] ==
                                                'resolved'
                                            ? Colors.green
                                            : Colors.green,
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //         'Rating: ${_report[index]['rating']}'),
                                    //     SizedBox(width: 10),
                                    //     Text(
                                    //         'Feedback: ${_report[index]['feedback']}'),
                                    //   ],
                                    // ),
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
                                    IconButton(
                                      icon: Icon(Icons.rate_review),
                                      onPressed: () {
                                        _showRatingAndFeedbackDialog(
                                            _report[index]['_id']);
                                      },
                                    ),
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

  void _showRatingAndFeedbackDialog(String reportId) {
    int rating = 0;
    String feedback = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rate and Provide Feedback"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'Rating (1-5)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  rating = int.tryParse(value) ?? 0;
                },
              ),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(labelText: 'Feedback'),
                onChanged: (value) {
                  feedback = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                submitRatingAndFeedback(reportId);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
