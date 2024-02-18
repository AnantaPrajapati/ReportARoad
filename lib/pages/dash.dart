import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token,Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}
 
class _DashboardState extends State<Dashboard> {

   late String email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    email = jwtDecodedToken['email'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onTabChange: (index){
              print(index);
            },
            tabs:const [
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
              text:'Settings',
              iconSize: 35, 
              textStyle: TextStyle(fontSize: 20, color: Colors.white), 
              ),
            ]
          ),
        ),
      ),
    );
  }
}