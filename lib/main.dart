import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reportaroad/pages/dash.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:reportaroad/pages/loginpage.dart';
import 'pages/loginpage.dart';
import 'pages/initialpage.dart';
import 'pages/verify.dart';
// import 'package:reportaroad/pages/l.dart';
import 'pages/Signuppage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(  MyApp(token: prefs.getString('token'),));
}

class MyApp extends StatelessWidget {

  final token;

  const MyApp ({
  @required this.token,
  Key? key,
  }): super (key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
        primaryTextTheme: GoogleFonts.latoTextTheme()
        ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: "/",
      routes: {
       // home: (JwtDecoder.isExpired(token) == false)?Dashboard(token: token):Loginpage()
        '/': (context) => const InitialPage(),
        '/loginpage': (context) =>  Loginpage(),
        '/signuppage': (context) => const Signuppage(),
        '/verify': (context) => const Verify(),
      },
    );
  }
}
