import 'package:flutter/material.dart';

class TitleDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const TitleDropdown({Key? key, required this.onChanged}) : super(key: key);

  @override
  _TitleDropdownState createState() => _TitleDropdownState();
}

class _TitleDropdownState extends State<TitleDropdown> {
  String _selectedTitle = 'Low'; 

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedTitle,
      items: <String>['Accident', 'Traffic Violation', 'Burglar']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTitle = newValue!;
          widget.onChanged(newValue);
        });
      },
    );
  }
}
