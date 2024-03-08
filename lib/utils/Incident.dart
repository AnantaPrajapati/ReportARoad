import 'package:flutter/material.dart';
import 'package:reportaroad/utils/reportsection.dart';

class ReportIncident extends StatefulWidget {
  const ReportIncident({Key? key}) : super(key: key);

  @override
  State<ReportIncident> createState() => _ReportIncidentState();
}

class _ReportIncidentState extends State<ReportIncident> {
  late double height;
  late double width;
  //padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  //report box
  List myIncidentSection = [
    //Reports
    ["Accident", "assets/images/warning.png", true],
    ["Traffic Violation", "assets/images/emergency.png", true],
    ["Accident", "assets/images/warning.png", true],
    ["Traffic Violation", "assets/images/emergency.png", true],
    ["Accident", "assets/images/warning.png", true],
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom appbar
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2C75FF),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate back to the previous page
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(
                              width:
                                  10), // Add some spacing between icon and text
                        ],
                      ),
                    ),
                    // Center the text vertically
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Report Incident",
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

            // Add more widgets here if needed
            const SizedBox(
              height: 5,
            ),

            Expanded(
                child: GridView.builder(
                    itemCount: myIncidentSection.length,
                    padding: const EdgeInsets.all(25),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return RerportSection(
                          ReportSectionName: myIncidentSection[index][0],
                          iconPath: myIncidentSection[index][1]);
                    }))
          ],
        ),
      ),
    );
  }
}
