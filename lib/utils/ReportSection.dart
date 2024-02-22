import 'package:flutter/material.dart';

class RerportSection extends StatelessWidget {
  final String ReportSectionName;
  final String iconPath;

  
  const RerportSection({super.key,
  required this.ReportSectionName,
  required this.iconPath,
  });

  

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration (
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
          ) ,
          padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //icon
            Image.asset(
              iconPath, 
              height: 45,
              ),
      
      
            //Report section name 
           Row(
            children: [
               Expanded(
                // child: Padding(
                  // padding: const EdgeInsets.only(left:7.0),
                  child: Text(
                    ReportSectionName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,  
                    ),
                    textAlign: TextAlign.center, 
                    ),
                )
                // ),
            ],
           )
      
        ],
        )
      ),
    );
  }
}
