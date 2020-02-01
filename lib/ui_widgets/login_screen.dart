import 'package:dogs_path/themes/colors.dart';
import 'package:dogs_path/themes/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Sign In',
              style:
              headingTextStyle.copyWith(color: Colors.white, fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Sign in with your facebook account',
              style: titleTextStyle.copyWith(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: orientation == Orientation.portrait
                ? EdgeInsets.symmetric(horizontal: 30)
                : EdgeInsets.symmetric(horizontal: width * .3),
            child: RaisedButton(
              onPressed: () {
                startFBLogin();
              },
              color: Color(0xFF3B5998),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    'f',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Sign in with Facebook',
                    style: titleTextStyle.copyWith(
                      fontFamily: 'LatoRegular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(
                    flex: 4,
                  ),
                ],
              ),
            ),
          ),
          Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }

  void startFBLogin() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:

      //todo: store access token in shared preference.
        _storeTokenToSharedPreference(result.accessToken.token);
        _showLoggedInUI(result.accessToken.token);

        break;
      case FacebookLoginStatus.cancelledByUser:
      //        todo: add toast message
      //        _showCancelledMessage();
        print('User Cancele Login Process');
        break;
      case FacebookLoginStatus.error:
//        todo: add toast message
//        _showErrorOnUI(result.errorMessage);
        print('Error while login: ' + result.errorMessage);
        break;
    }
  }

  void _storeTokenToSharedPreference(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fbToken', token);
  }

  void _showLoggedInUI(token) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) => new HomePage(fbToken: token)));
  }
}