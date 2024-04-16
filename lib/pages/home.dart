import 'package:flutter/material.dart';
import 'package:reportaroad/pages/BottomNav.dart'; 
import 'package:reportaroad/pages/Report.dart';
import 'package:reportaroad/pages/setting.dart';
import 'package:reportaroad/utils/incident.dart';
import 'package:reportaroad/utils/reportsection.dart'; 
import 'package:reportaroad/utils/EmergencyNumber.dart';
import 'package:reportaroad/utils/userlocation.dart'; 
import 'package:jwt_decoder/jwt_decoder.dart';


class Home extends StatelessWidget {
  final token;
  const Home({@required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomeScreen(token: token);
  }
}

class _HomeScreen extends StatefulWidget {
  final token;
  const _HomeScreen({@required this.token, Key? key}) : super(key: key);

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int _selectedIndex = 0;
  late double height;
  late double width;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  late String email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    email = jwtDecodedToken['email'];
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
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2C75FF),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
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
