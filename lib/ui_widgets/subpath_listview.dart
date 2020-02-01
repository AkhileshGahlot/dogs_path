import 'package:dogs_path/model/paths.dart';
import 'package:dogs_path/themes/colors.dart';
import 'package:dogs_path/themes/textStyle.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:flutter/material.dart';

///Vertical List View Holding Path List
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

///Card Showing Data Of Path List
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
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(top: 5,bottom: 5,left: 15,right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                       widget.path.title,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontFamily: "LatoRegular" ,
                        fontWeight:FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.path.subPaths.length} Sub Paths",
                      style: smallTextStyle.copyWith(
                        fontSize: 10
                      ),
                    ),
                  ],
                ),

                ButtonTheme(
                  height: 28,
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.black,
                    padding: EdgeInsets.all(0),
                    child: Text(
                      'Open Path',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
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

///Horizontal List View Holding and Showing subPath List Data
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
                                  fontWeight: FontWeight.bold,
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