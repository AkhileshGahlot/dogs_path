import 'dart:async';
import 'package:dogs_path/themes/colors.dart';
import 'package:dogs_path/themes/textStyle.dart';
import 'package:dogs_path/ui_widgets/home_page.dart';
import 'package:dogs_path/ui_widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenScreen(),
//      MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SplashScreenScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenScreen> {

  @override
  void initState() {
    super.initState();

    //todo check for authentication

    new Timer(new Duration(seconds: 1), () {
      checkFbToken();
    });
  }


  Future checkFbToken() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    /* Store Your refresh and access token instead */

    String fbToken = (prefs.get('fbToken') ?? null);

    if (fbToken!=null) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new HomePage()));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 4,
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: 100,
              maxWidth: 100,
            ),
            child: Image.asset(
              'assets/gif/image.gif',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Dog's Path",
            style: headingTextStyle,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'by',
              style: smallTextStyle,
            ),
          ),
          Text(
            "VirtouStack Softwares Pvt. Ltd.",
            style: titleTextStyle,
          ),
          Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}
