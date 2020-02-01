import 'dart:convert';

import 'package:dogs_path/bloc/path_listing_bloc.dart';
import 'package:dogs_path/themes/colors.dart';
import 'package:dogs_path/themes/textStyle.dart';
import 'package:flutter/services.dart';
import '../model/paths.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'subpath_listview.dart';

class HomePage extends StatefulWidget {
  final String fbToken;

  const HomePage({Key key, this.fbToken}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  PathListingBloc _listingBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
//      DeviceOrientation.landscapeLeft,
    ]);

    _listingBloc = PathListingBloc()..fetchPaths();
    if(widget.fbToken!=null)
      _sendTokenToServer(widget.fbToken);
  }

  @override
  void dispose() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    _listingBloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _sendTokenToServer(String token) async {
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');

    if (graphResponse.statusCode == 200) {
      _showAlert(context, json.decode(graphResponse.body)['name']);
    }
  }

  void _showAlert(BuildContext context,String name) {
    showDialog(
         barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(0xFAC3C3C5),
            contentPadding: EdgeInsets.only(left: 0,right: 0,top: 15,bottom: 10),
            content: Container(
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Alert",
                  style: TextStyle(
                    color: Color(0xFF5F5C63),

                    fontWeight: FontWeight.bold,
                    fontFamily: 'LatoRegular',
                    fontSize: 18,
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:10.0),
                    child: Text("Signed in as $name",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF5F5C63),
                        fontFamily: 'LatoRegular',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: Color(0xAA5F5C63),
                  ),
                  FlatButton(
                    child: Text("OK",
                      style: TextStyle(
                        color: Color(0xFF0091C6),
//                        fontWeight: FontWeight.bold,
                        fontFamily: 'LatoRegular',
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            )

    )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          "Dog's Path",
          style: titleTextStyle.copyWith(
            color: titleColor
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: StreamBuilder<List<Path>>(
              stream: _listingBloc.pathListStream,
              builder: (context,AsyncSnapshot<List<Path>> snapshot) {

                if(snapshot.hasData){
                  return PrimaryListView(
                    pathList: snapshot.data,
                  );
                }
                return Center(child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(titleColor),
                ),);
              }
          ),
        ),
      ),
    );
  }
}
