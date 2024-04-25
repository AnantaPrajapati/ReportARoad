import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reportaroad/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class ViewReports extends StatefulWidget {
  // final String email;
   final String userId;
   final token;
    ViewReports( {super.key, required this.userId, required this.token});
  @override
  _ViewReportsState createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  late List<dynamic> report = [];
 
  // late String email;

  @override
  void initState() {
    super.initState();
    // Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    // userId = jwtDecodedToken['_id'];
    //  getReport(userId);
    getReport(widget.userId);
   
  }


  void getReport(userId)async{
    var reqBody = {
        "userId": widget.userId,
      };
       var response = await http.post(Uri.parse('${serverBaseUrl}getReport'),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(reqBody));

          var jsonResponse = jsonDecode(response.body);
          report = jsonResponse['success'];
  }

    void deleteReport() async{
    var regBody = {
      "userID": widget.userId,
    };
    var response = await http.post(Uri.parse('${serverBaseUrl}deleteReport'),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );
    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['status']){
      getReport(userId);
    }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.lightBlueAccent,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: report == null
                  ? Center(child: CircularProgressIndicator()) 
                  : ListView.builder(
                      itemCount: report!.length,
                      itemBuilder: (context, int index) {
                        return Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {}),
                            children: [
                              SlidableAction(
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (BuildContext context) {
                                  print('${report[index]['_id']}');
                                  // deleteReport('${report![index]['_id']}');
                                },
                              ),
                            ],
                          ),
                          child: Card(
                            borderOnForeground: false,
                            child: ListTile(
                              leading: Icon(Icons.task),
                              title: Text('${report![index]['severity']}'),
                              subtitle: Text('${report![index]['desc']}'),
                              trailing: Icon(Icons.arrow_back),
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