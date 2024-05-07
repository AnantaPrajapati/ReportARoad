// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:reportaroad/pages/BottomNav.dart';
// import 'package:reportaroad/pages/Report.dart';
// import 'package:reportaroad/pages/UpdatedReport.dart';
// import 'package:reportaroad/pages/ViewReport.dart';
// import 'package:reportaroad/pages/Notification.dart';
// import 'package:reportaroad/pages/setting.dart';
// import 'package:reportaroad/utils/reportsection.dart';
// import 'package:reportaroad/utils/EmergencyNumber.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:reportaroad/utils/slide_menu.dart';
// import 'package:reportaroad/pages/IncidentReport.dart';

// import '../main.dart';

// // class Home extends StatelessWidget {
// //   final token;
// //   String id;
// //   Home({required this.token, required this.id, Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return _HomeScreen(token: token, id: id);
// //   }
// // }

// class Home extends StatefulWidget {
//   final token;
//   String id;
//   Home({required this.token, required this.id, Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => HomeState();
// }

// class HomeState extends State<Home> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _selectedIndex = 0;
//   late double height;
//   late double width;
//   final double horizontalPadding = 40;
//   final double verticalPadding = 25;
//   late bool hasAskedForLocationPermission;
//   late String username;
//   late String userId;
//   late String token;
//   int reportCount = 0;

// //anantaprajapati0@gmail.com
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

//     email = jwtDecodedToken['email'];
//     userId = jwtDecodedToken['_id'];
//     username = jwtDecodedToken['username'];
//     token = widget.token;
//     // if (jwtDecodedToken.containsKey('Username')) {
//     //   username = jwtDecodedToken['Username'];
//     // }
//     hasAskedForLocationPermission = false;
//     _checkLocationPermission();

//     // ViewReports(userId: userId, token: token,);
//   }

//   void updateReportCount(int count) {
//     setState(() {
//       reportCount = count;
//     });
//   }

//   Future<void> _checkLocationPermission() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (!hasAskedForLocationPermission) {
//       try {
//         Position position = await _location();
//         print(
//             'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//       } catch (e) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Location Permission'),
//             content: Text('$e'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }

//       setState(() {
//         hasAskedForLocationPermission = true;
//       });
//       prefs.setBool('hasAskedForLocationPermission', true);
//     }
//   }

//   Future<Position> _location() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();

//     if (!serviceEnabled) {
//       throw Exception("Please enable the location");
//     }
//     permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception("Location permission is denied");
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception(
//           "Location permission is permanently denied!! Please enable location to access location");
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     return position;
//   }

//   List myReportSection = [
//     // Reports
//     ["Report Incidents", "assets/images/warning.png", true],
//     ["Emergency Numbers", "assets/images/emergency.png", true],
//   ];

//   void _onTabChange(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 5),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Welcome home,"),
//                   Text(username,
//                       style:
//                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//               child: Table(
//                 columnWidths: {
//                   0: FlexColumnWidth(1),
//                   1: FlexColumnWidth(1),
//                 },
//                 children: [
//                   TableRow(
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             height: 1,
//                             color: Colors.black,
//                           ),
//                           const SizedBox(height: 5),
//                           Center(child: Text("Potholes report")),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Container(
//                             height: 1,
//                             color: Colors.black,
//                           ),
//                           const SizedBox(height: 5),
//                           Center(child: Text("Potholes fixed")),
//                         ],
//                       ),
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       Column(
//                         children: [
//                           const SizedBox(height: 5),
//                           Center(child: Text("$reportCount")),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           const SizedBox(height: 5),
//                           Center(
//                             child: Text("1"),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5.0),
//             SingleChildScrollView(
//               child: GridView.builder(
//                 itemCount: 2,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(25),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                 ),
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       if (index == 0) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => IncidentReport(email: email),
//                           ),
//                         );
//                       } else if (index == 1) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => EmergencyNumber(),
//                           ),
//                         );
//                       }
//                     },
//                     child: RerportSection(
//                       ReportSectionName: myReportSection[index][0],
//                       iconPath: myReportSection[index][1],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       Report(
//         userId: userId,
//         token: widget.token,
//         updateReportCount: updateReportCount,
//       ),
//       ViewReports(
//         userId: userId,
//         token: widget.token,
//       ),
//       UpdatedReport(
//         userId: userId,
//         token: widget.token,
//       ),
//       const SettingPage()
//     ];

//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(_selectedIndex == 0 ? 90 : 0),
//         child: Center(
//           child: _selectedIndex == 0
//               ? Container(
//                   color: Color(0xFF2C75FF),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: horizontalPadding,
//                       vertical: 30,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             _scaffoldKey.currentState?.openDrawer();
//                           },
//                           child: Image.asset(
//                             "assets/images/menu.png",
//                             height: 45,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Stack(
//                           children: [
//                             GestureDetector(
//                               // onTap: () {
//                               //   Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(builder: (context) => Notificaton()),
//                               //   );
//                               // },
//                               child: Icon(
//                                 Icons.notification_add,
//                                 size: 35,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               child: Container(
//                                 padding: EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   '8',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : null,
//         ),
//       ),
//       drawer: Container(
//         width: MediaQuery.of(context).size.width * 0.7,
//         color: Colors.white,
//         child: SlideMenu(
//           userId: userId,
//           id: '',
//         ),
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: pages,
//       ),
//       bottomNavigationBar: BottomNav(
//         selectedIndex: _selectedIndex,
//         onTabChange: _onTabChange,
//       ),
//     );
//   }
// }