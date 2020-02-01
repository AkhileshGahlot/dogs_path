import 'package:dogs_path/bloc/path_listing_bloc.dart';
import 'package:dogs_path/model/paths.dart';
import 'package:dogs_path/themes/colors.dart';
import 'package:dogs_path/themes/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_widgets/flutter_widgets.dart';

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
      home: HomePage(),
//      MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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

    _listingBloc = PathListingBloc()..fetchPaths();

//    .convertJsonArray(json.decode(serverData));

    if(widget.fbToken!=null)_sendTokenToServer(widget.fbToken);

  }

  @override
  void dispose() {
    _listingBloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _sendTokenToServer(String token) async {
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    print(graphResponse.body);
    _showAlert(context);
    if (graphResponse.statusCode == 200) {
      _showAlert(context);
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,

        barrierDismissible: false,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Color(0xC3C3C5),
            content: Container(
              child: Column(
                children: <Widget>[
                  Text("Alert"),
                  Text("Signed in as ${widget.fbToken}"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            )));
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
          style: titleTextStyle,
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

              return Center(child: CircularProgressIndicator(),);
            }
          ),
        ),
      ),
    );
  }
}

///Vertical List View
class PrimaryListView extends StatefulWidget {
  final List<Path> pathList;

  const PrimaryListView({Key key, this.pathList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrimaryListViewState();
  }
}

class _PrimaryListViewState extends State<PrimaryListView> {

  @override
  void didUpdateWidget(PrimaryListView oldWidget) {

    /** ON Occurrence of second Snapshot list Update the pathList
      *  by first adding oldWidget(previous object) List
      *  and then newWidget(new object) list.
      *  final list =oldWidget.pathList;
      *  list = list.add(pathList);
     */
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: widget.pathList.length - 1,
      itemBuilder: (context, index) {
        if (widget.pathList.length == 0) {
          return Center(child: CircularProgressIndicator());
        }
        return SecondaryListCards(path: widget.pathList.elementAt(index));
      },
    );
  }
}

class SecondaryListCards extends StatefulWidget {
  final Path path;

  const SecondaryListCards({Key key, this.path}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SecondaryListCards();
  }
}

class _SecondaryListCards extends State<SecondaryListCards> {
  ItemScrollController scrollController;
  PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ItemScrollController();
    pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  void didUpdateWidget(SecondaryListCards oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 300,
      constraints: BoxConstraints(maxHeight: 300),
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.path.title != null
                          ? widget.path.title
                          : "NO TItle",
                      style: titleTextStyle,
                    ),
                    Text(
                      widget.path.subPaths.length != null
                          ? "${widget.path.subPaths.length} SUb Paths"
                          : "NO path",
                      style: smallTextStyle,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {},
                color: Colors.black,
                child: Text(
                  'Open Path',
                  style: buttonTextStyle,
                ),
              ),
            ],
          ),
          SecondaryListView(
            subPaths: widget.path.subPaths,
            scrollController: scrollController,
            pageController: pageController,
          ),
        ],
      ),
    );
  }
}

///Horizontal List View
class SecondaryListView extends StatefulWidget {
  final List<SubPaths> subPaths;
  final ItemScrollController scrollController;
  final PageController pageController;
  SecondaryListView(
      {@required this.subPaths,
      @required this.scrollController,
      @required this.pageController});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SecondaryListViewState();
  }
}

class _SecondaryListViewState extends State<SecondaryListView> {
  int selectedPage = 0;
  bool pageLock = true;

  freePageLock(a) {
    pageLock = true;
  }

  selectedSubPath(int value, String caller) {
    print("called111");

    if (caller == 'text') {

      setState(() {
        pageLock = false;
        selectedPage = value;
        widget.pageController
            .animateToPage(value,
                duration: Duration(seconds: 1), curve: Curves.easeInOut)
            .then(freePageLock);
      });
    } else {
     
      setState(() {
        selectedPage = value;
        widget.scrollController.scrollTo(
            index: value,
            duration: Duration(microseconds: 50),
            curve: Curves.easeInOut);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Stack(
        children: <Widget>[
          PageView.builder(
              onPageChanged: (int value) {
                if (pageLock) selectedSubPath(value, 'page');
              },
              controller: widget.pageController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.subPaths.length - 1,
              itemBuilder: (context, index) {
                return FadeInImage.assetNetwork(
                  image: widget.subPaths.elementAt(index).image,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  placeholder: "assets/gif/image.gif",
                );
              }),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 60,
                ),
//                : RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(0.0)),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.black,
//                elevation: 16,
                child: ScrollablePositionedList.builder(
                    itemScrollController: widget.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.subPaths.length - 1,
                    itemBuilder: (context, index) {
                      return Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed:(){

                              selectedSubPath(index, 'text');
                            },
                            child: Text(widget.subPaths.elementAt(index).title,
                                style: titleTextStyle.copyWith(
                                  color: selectedPage == index
                                      ? titleColor
                                      : button2TextColor,
                                )),
                          ),
                          index != widget.subPaths.length - 2
                              ? Icon(
                                  Icons.arrow_forward,
                                  color: titleColor,
                                )
                              : SizedBox.shrink(),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    //todo check for authentication

//    new Timer(new Duration(seconds: 3), () {
//      Navigator.of(context).pushReplacement(new MaterialPageRoute(
//          builder: (context) => new MyHomePage(title: 'Okie')));
//    });
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
//        _sendTokenToServer(result.accessToken.token);
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

//  void _sendTokenToServer(String token) async {
//    final graphResponse = await http.get(
//        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
//    print(graphResponse.body);
//  }

  void _showLoggedInUI(token) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (context) => new HomePage(fbToken: token)));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
