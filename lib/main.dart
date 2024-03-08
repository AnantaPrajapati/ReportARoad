import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:reportaroad/pages/dash.dart';
import 'package:reportaroad/pages/home.dart';
import 'package:reportaroad/userAuthentication/initialpage.dart';
// import 'package:reportaroad/userAuthentication/loginpage.dart';
// import 'package:reportaroad/userAuthentication/verify.dart';
// import 'package:reportaroad/userAuthentication/verifypass.dart';

// import 'package:reportaroad/utils/order_tracking_page.dart';
import 'package:reportaroad/utils/userlocation.dart';
import 'package:reportaroad/utils/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          // '/': (context) => const OrderTrackingPagState(),
          //  '/': (context) => const Userlocationpage(),
          //  '/': (context) => const Dashboard(),
            // '/': (context) => const Home(),
              '/': (context) => Map(),
        // '/': (context) => const InitialPage(),
      //   '/':(context) => const VerifyPass(verEmail: '',)
      //   '/loginpage': (context) =>  Loginpage(),
      //   '/signuppage': (context) => const Signuppage(),
      //   '/verify': (context) => const Verify(),
      },
    );
  }
}
