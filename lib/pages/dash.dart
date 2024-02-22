import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reportaroad/utils/reportsection.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double height;
  late double width;
  //padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  //report box
  List myReportSection = [
    //Reports
    ["Report Incidents", "assets/images/warning.png", true],
    ["Emergency Numbers", "assets/images/emergency.png", true],
  ];

  //  late String email;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

  //   email = jwtDecodedToken['email'];
  // }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      //  body: Column(
      //   children: [
      //   Container(
      //     decoration: BoxDecoration(
      //       color: Color(0xFF2C75FF),
      //     ),
      //     height: height *0.25,
      //     width: width,
      //     ),
      //   ],
      //  ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom appbar
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2C75FF),
              ),
              //  height: height *0.09,
              // width: width,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu icon
                    Image.asset(
                      "assets/images/menu.png",
                      height: 35,
                      color: Colors.white,
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
            // Add more widgets here if needed
            const SizedBox(
              height: 5,
            ),
            //welcome home

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Welcome home,"),
                  Text("ReportARoad", style: TextStyle(fontSize: 25)),
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
                  0: FlexColumnWidth(1), // Adjust column width as needed
                  1: FlexColumnWidth(1), // Adjust column width as needed
                },
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 1, // Height of the horizontal divider
                            color:
                                Colors.black, // Color of the horizontal divider
                          ),
                          const SizedBox(height: 5),
                          Center(child: Text("Potholes report")),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 1, // Height of the horizontal divider
                            color:
                                Colors.black, // Color of the horizontal divider
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
                      height: 1, // Height of the divider
                      color: Colors.black, // Color of the divider
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
                    itemCount: myReportSection.length,
                    padding: const EdgeInsets.all(25),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return RerportSection(
                          ReportSectionName: myReportSection[index][0],
                          iconPath: myReportSection[index][1]);
                    }))
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: Color(0xFF2C75FF),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Color(0xFF2C75FF),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.withOpacity(0.5),
              padding: EdgeInsets.all(16),
              gap: 8,
              onTabChange: (index) {
                print(index);
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  iconSize: 35,
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'Report',
                  iconSize: 35,
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconSize: 35,
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ]),
        ),
      ),
    );
  }
}
