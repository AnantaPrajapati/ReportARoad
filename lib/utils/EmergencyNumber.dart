import 'package:flutter/material.dart';
import 'package:reportaroad/models/Ambulance.dart';
import 'package:reportaroad/models/BloodBank.dart';
import 'package:reportaroad/models/FireBrigade.dart';
import 'package:reportaroad/models/NearbyHospital.dart';
import 'package:reportaroad/models/PoliceStation.dart';
import 'package:reportaroad/utils/ReportSection.dart';


class EmergencyNumber extends StatefulWidget {
  const EmergencyNumber({ Key? key}) : super(key: key);

  @override
  State<EmergencyNumber> createState() => _EmergencyNumberState();
}

class _EmergencyNumberState extends State<EmergencyNumber> {
  late double height;
  late double width;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;


  List myIncidentSection = [
    ["Hospital", "assets/images/Hospital.png", true],
    ["Blood Bank", "assets/images/Blood.png", true],
     ["Fire Brigade", "assets/images/Fire.png", true],
    ["Ambulance", "assets/images/Ambulance.png", true],
     ["Police Station", "assets/images/Police.png", true],
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
                                  10),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Emergency Location",
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
            const SizedBox(
              height: 5,
            ),

            Expanded(
              child: GridView.builder(
                itemCount: myIncidentSection.length,
                padding: const EdgeInsets.all(25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      
                      if (myIncidentSection[index][0] == "Hospital") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewAddressPage(),
                        ));
                      }
                      if (myIncidentSection[index][0] == "Ambulance") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Ambulance(),
                        ));
                      }
                      if (myIncidentSection[index][0] == "Blood Bank") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BloodBank(),
                        ));
                      }
                      if (myIncidentSection[index][0] == "Police Station") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PoliceStation(),
                        ));
                      }
                       if (myIncidentSection[index][0] == "Fire Brigade") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FireBrigade(),
                        ));
                      }
                    },
                    child: ReportSection( 
                      ReportSectionName: myIncidentSection[index][0],
                      iconPath: myIncidentSection[index][1],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}