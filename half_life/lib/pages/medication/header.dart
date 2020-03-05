import 'package:flutter/material.dart';
import 'package:half_life/doseChart.dart';
import 'package:half_life/halfLifeChanger.dart';
import 'package:half_life/pages/medication/add/buttons.dart';
import 'package:half_life/struct/doses.dart';

class HeaderSliver extends StatefulWidget {
  const HeaderSliver({
    Key key,
    @required this.statusBarHeight,
    @required this.appBarHeight,
    @required this.accentHeight,
    @required this.bottomBarHeight,
    //other
    @required this.addingDose,
    @required this.theSelectedDateTime,
    @required this.lastDateTime,
    @required this.dosesVN,
    @required this.doseIDtoActiveDoseVN,
    @required this.halfLife,
  }) : super(key: key);

  final double statusBarHeight;
  final double appBarHeight;
  final double accentHeight;
  final double bottomBarHeight;
  //other
  final ValueNotifier<bool> addingDose;
  final ValueNotifier<DateTime> theSelectedDateTime;
  final ValueNotifier<DateTime> lastDateTime;
  final ValueNotifier<List<Dose>> dosesVN;
  final ValueNotifier<Map<int, double>> doseIDtoActiveDoseVN;
  final ValueNotifier<Duration> halfLife;

  @override
  _HeaderSliverState createState() => _HeaderSliverState();
}

class _HeaderSliverState extends State<HeaderSliver> {
  //eventually object updaters
  final TextEditingController textCtrl =
      new TextEditingController(text: "Fluvoxamine");

  //build
  @override
  Widget build(BuildContext context) {
    double flexibleHeight =
        widget.accentHeight; //the bottom bar is included here
    //add extra space for visual elements that wont be the accent color
    //flexibleHeight += widget.statusBarHeight; //equivalent to bottom buttons not factored into ratio
    flexibleHeight += widget.appBarHeight;

    //build
    return SliverAppBar(
      backgroundColor: Theme.of(context).accentColor,
      //the top title (is basically the bottom AppBar)
      //NOTE: leading to left of title
      //NOTE: title in middle
      //NOTE: action to right of title

      //don't show extra top padding
      primary: false,
      //only show shadow if content below
      forceElevated: false,
      //snapping is annoying and disorienting
      //but the opposite is ugly
      snap: false,
      //on se we can always add a dose and change the medication settings
      pinned: true,
      //might make it open in annoying times (so we turn it off)
      floating: false,
      //tool bar
      bottom: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          widget.bottomBarHeight,
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).accentColor,
                        Theme.of(context).accentColor.withOpacity(0.0),
                      ],
                      stops: [0.65, 1],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                    ),
                    onPressed: () {
                      print("back to medication list");
                    },
                  ),
                ),
              ),
              //spacer so resizing doses doesn't get covered
              Opacity(
                opacity: 0,
                child: Text(
                  "Doses",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).accentColor,
                        Theme.of(context).accentColor.withOpacity(0.0),
                      ],
                      stops: [0.65, 1],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: DoseAddButtons(
                    addingDose: widget.addingDose,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //most of the screen
      expandedHeight: flexibleHeight,
      //the graph
      flexibleSpace: FlexibleSpaceBar(
        //scaling title
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(
            bottom: 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).accentColor.withOpacity(0.0),
              ],
              stops: [0.75, 1],
              tileMode: TileMode.repeated,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              "Doses",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0),
        //pin, pins on bottom
        //parallax keeps the background centered within flexible space
        collapseMode: CollapseMode.parallax,
        //TODO: check if this is working at all
        stretchModes: [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
        ],
        //the background with the graph and active dose
        background: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: ThemeData.dark().primaryColorDark,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: widget.statusBarHeight,
                bottom: widget.bottomBarHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: PreferredSize(
                      preferredSize: Size(
                        MediaQuery.of(context).size.width,
                        widget.appBarHeight,
                      ),
                      child: AppBar(
                        backgroundColor: ThemeData.dark().primaryColorDark,
                        //not on top of screen
                        primary: false,
                        //give the edit half life button space
                        centerTitle: false,
                        //medication name
                        title: TextField(
                          controller: textCtrl,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Medication Name',
                          ),
                          //only 1 line at all times
                          expands: false,
                          minLines: 1,
                          maxLines: 1,
                        ),
                        //change half life name
                        actions: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            child: HalfLifeChanger(
                              halfLife: widget.halfLife,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).accentColor,
                      child: HeaderChart(
                        lastDateTime: widget.lastDateTime,
                        theSelectedDateTime: widget.theSelectedDateTime,
                        screenWidth: MediaQuery.of(context).size.width,
                        halfLife: widget.halfLife.value,
                        doses: widget.dosesVN.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}