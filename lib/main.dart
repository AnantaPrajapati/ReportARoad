import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportaroad/pages/ViewReport.dart';
import 'package:reportaroad/userAuthentication/loginpage.dart';
import 'package:reportaroad/utils/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

String serverBaseUrl='http://192.168.254.6:3000/';
late String token;
late String email;
late String username;
late String userId;
// late Map<String, dynamic> decodedToken;

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
    //   if (token != null) {
    //   Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    //   DecodedToken = jwtDecodedToken;
    // }
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
         primaryTextTheme: GoogleFonts.latoTextTheme(),
        ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: "/",
      routes: {
       // home: (JwtDecoder.isExpired(token) == false)?Dashboard(token: token):Loginpage()
          //  '/': (context) => const Userlocationpage(),
          //  '/': (context) => const Dashboard(),
            // '/': (context) => const Home(),
              // '/': (context) => Map(),
        // '/': (context) => const InitialPage(),
      //   '/':(context) => const VerifyPass(verEmail: '',)
        '/': (context) =>  const Loginpage(),
          // '/': (context) =>  ViewReports(userId:userId, token: token,),
        // '/signuppage': (context) => const Signuppage(),
      //   '/verify': (context) => const Verify(),
      },
    );
  }
}
