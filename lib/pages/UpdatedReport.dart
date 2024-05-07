import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reportaroad/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dotted_border/dotted_border.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    if (ratingController.text.isNotEmpty &&
        feedbackController.text.isNotEmpty) {
      var regBody = {
        "rating": ratingController.text,
        "feedback": feedbackController.text,
      };

      var response = await http.post(
        Uri.parse(
            '${serverBaseUrl}ratingFeedback?reportId=$reportId&userId=${widget.userId}'),
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
        } else {
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
                    child: Text(
                        'You have already submitted a rating and feedback for this report'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        var errorMessage = 'An error occurred';
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
                  child: Text('OK'),
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
              "Updated Report",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                                leading: _report[index]['images'] != null && _report[index]['images'].isNotEmpty
                                ? GestureDetector(
                                  onTap: () {
                                    _showReportDetailsDialog(_report[index]);
                                  },
                                  child:  Hero(
                                          tag: 'imageHero$index',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              _report[index]['images'][0],
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        )
                                  
                                )
                                  : Icon(Icons.task),
                                title: const Text(
                                  'Your reported incident has been fixed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Severity: ${_report[index]['severity']}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Text(
                                      'Location: ${_report[index]['location']}',
                                      style: const TextStyle(
                                        color: Color(0xFF2C75FF),
                                      ),
                                    ),
                                    Text(
                                      'Description: ${_report[index]['desc']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
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
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.grey[200],
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF2C75FF),
                primary: Colors.white,
              ),
            ),
          ),
          child: AlertDialog(
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
          ),
        );
      },
    );
  }

 void _showImageDialog(BuildContext context, List<String> imageUrls, int index) {
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
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                        _showImageDialog(context, reportDetails['images'], index);
                      },
                      child: Hero(
                        tag: 'imageHero${reportDetails['_id']}_$index',
                        child: Image.network(
                          reportDetails['images'][index],
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Text('Severity: ${reportDetails['severity']}'),
              Text('Location: ${reportDetails['location']}'),
              Text('Description: ${reportDetails['desc']}'),
              Text('Status: ${reportDetails['status'] ?? 'resolved'}'),
              if (reportDetails['rating'] != null)
                Text('Rating: ${reportDetails['rating']}'),
              if (reportDetails['feedback'] != null)
                Text('Feedback: ${reportDetails['feedback']}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
}
