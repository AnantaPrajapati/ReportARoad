import 'package:flutter/material.dart';

class SeverityDropdown extends StatefulWidget {
  @override
  _SeverityDropdownState createState() => _SeverityDropdownState();
}

class _SeverityDropdownState extends State<SeverityDropdown> {
  String selectedSeverity = 'Low';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedSeverity,
      onChanged: (String? newValue) {
        setState(() {
          selectedSeverity = newValue!;
        });
      },
      items: <String>['Low', 'Medium', 'High'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // decoration: InputDecoration(
      //   labelText: 'Severity',
      //   labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      //   border: OutlineInputBorder(),
      //   contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      // ),
    );
  }
}
