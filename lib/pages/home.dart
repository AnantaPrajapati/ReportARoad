import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reportaroad/pages/BottomNav.dart'; 
import 'package:reportaroad/pages/Report.dart';
import 'package:reportaroad/pages/setting.dart';
import 'package:reportaroad/utils/incident.dart';
import 'package:reportaroad/utils/reportsection.dart'; 
import 'package:reportaroad/utils/EmergencyNumber.dart';
import 'package:reportaroad/utils/userlocation.dart'; 
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reportaroad/utils/slide_menu.dart';


class Home extends StatelessWidget {
  final token;
  String id;
   Home({required this.token, required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomeScreen(token: token, id: id);
  }
}

class _HomeScreen extends StatefulWidget {
  final token;
  String id;
   _HomeScreen({required this.token, required this.id, Key? key}) : super(key: key);

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  late double height;
  late double width;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;
  late bool hasAskedForLocationPermission;

  late String email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
     hasAskedForLocationPermission = false;
    _checkLocationPermission();
  }

 
  Future<void> _checkLocationPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // If the user has not been asked for location permission, ask for permission
    if (!hasAskedForLocationPermission) {
      try {
        Position position = await _location();
        print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      } catch (e) {
        // Handle errors or denied permissions
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Location Permission'),
            content: Text('$e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
      // Update the flag to indicate that the user has been asked for location permission
      setState(() {
        hasAskedForLocationPermission = true;
      });
      // Save the updated flag in SharedPreferences
      prefs.setBool('hasAskedForLocationPermission', true);
    }
  }

  Future<Position> _location() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Please enable the location");
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission is denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission is permanently denied!! Please enable location to access location");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  List myReportSection = [
    // Reports
    ["Report Incidents", "assets/images/warning.png", true],
    ["Emergency Numbers", "assets/images/emergency.png", true],
  ];

  void _onTabChange(int index){
    setState(() {
      _selectedIndex= index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Scaffold(
        body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom app bar
            // Container(
            //   height: 100, // Adjust the height of the blue container
            //   color: Color(0xFF2C75FF), // Blue color
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: horizontalPadding,
            //       vertical: 20,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         // Menu icon
            //         IconButton(
            //           icon: Image.asset(
            //             "assets/images/menu.png",
            //             height: 35,
            //             color: Colors.white,
            //           ),
            //           onPressed: (){
            //             _scaffoldKey.currentState?.openDrawer();
            //           },
            //         ),
            //         const Icon(
            //           Icons.notification_add,
            //           size: 35,
            //           color: Colors.white,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome home,"),
                  Text(email, style: TextStyle(fontSize: 25)),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 1,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          Center(child: Text("Potholes report")),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 1,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          Center(child: Text("Potholes fixed")),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 2, 
                padding: const EdgeInsets.all(25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportIncident(),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmergencyNumber(),
                          ),
                        );
                      }
                    },
                    child: RerportSection(
                      ReportSectionName: myReportSection[index][0],
                      iconPath: myReportSection[index][1],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
      Report(email: email),
      // const Userlocationpage(),
      const SettingPage()
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Adjust the height of the app bar
        child: Container(
          color: Color(0xFF2C75FF), // Blue color
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Menu icon
                IconButton(
                  icon: Image.asset(
                    "assets/images/menu.png",
                    height: 35,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                const Icon(
                  Icons.notification_add,
                  size: 35,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.7, // Set the width of the drawer
        color: Colors.white, // White color
        child: SlideMenu(id: widget.id),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
