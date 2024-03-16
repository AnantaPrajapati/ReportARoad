import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reportaroad/pages/home.dart';
// import 'package:reportaroad/pages/report_screen.dart'; // Import the ReportScreen widget
// import 'package:reportaroad/pages/settings_screen.dart'; // Import the SettingsScreen widget

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  const BottomNav({required this.selectedIndex, required this.onTabChange, super.key});

  // static List<Widget> _widgetOptions = <Widget>[
  //   BottomNav(), // Replace BottomNav() with Home() or appropriate widget
  //   // ReportScreen(),
  //   // SettingsScreen(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF2C75FF),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: Color(0xFF2C75FF),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.withOpacity(0.5),
            padding: EdgeInsets.all(16),
            gap: 8,
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: [
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
            ],
          ),
        ),
      );
  }
}
