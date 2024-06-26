import 'package:flutter/material.dart';

class SeverityDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SeverityDropdown({Key? key, required this.onChanged}) : super(key: key);

  @override
  _SeverityDropdownState createState() => _SeverityDropdownState();
}

class _SeverityDropdownState extends State<SeverityDropdown> {
  String _selectedSeverity = 'Low'; 

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedSeverity,
      items: <String>['Low', 'Medium', 'High']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedSeverity = newValue!;
          widget.onChanged(newValue);
        });
      },
    );
  }
}
