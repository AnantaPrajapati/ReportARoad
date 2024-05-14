import 'package:flutter/material.dart';

class CityDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const CityDropdown({Key? key, required this.onChanged}) : super(key: key);

  @override
  _CityDropdownState createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  String _selectedCity = 'Kathmandu'; // Capitalized city names

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCity,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
        ),
        items: <String>['Kathmandu', 'Bhaktapur', 'Lalitpur']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCity = newValue!;
            widget.onChanged(newValue);
          });
        },
      ),
    );
  }
}
