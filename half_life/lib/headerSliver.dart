import 'package:flutter/material.dart';
import 'package:half_life/doseChart.dart';
import 'package:half_life/struct/doses.dart';

class HeaderSliver extends StatelessWidget {
  const HeaderSliver({
    Key key,
    @required this.context,
    @required this.bottomBarHeight,
    @required this.chartHeight,
    @required this.statusBarHeight,
    @required this.lastDateTime,
    @required this.doses,
    @required this.halfLife,
  }) : super(key: key);

  final BuildContext context;
  final double bottomBarHeight;
  final double chartHeight;
  final double statusBarHeight;
  final ValueNotifier<DateTime> lastDateTime;
  final List<Dose> doses;
  final Duration halfLife;

  @override
  Widget build(BuildContext context) {
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
          bottomBarHeight,
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                ), 
                onPressed: (){
                  print("back to medication list");
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  print("add dose");
                },
              ),
            ],
          ),
        ),
      ),
      //most of the screen
      expandedHeight: chartHeight,
      //the graph
      flexibleSpace: FlexibleSpaceBar(
        //scaling title
        centerTitle: true,
        title: Text(
          "Doses",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        titlePadding: EdgeInsets.only(
          bottom: 12,
        ),
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
              height: chartHeight,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: statusBarHeight,
                bottom: bottomBarHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: PreferredSize(
                      preferredSize: Size(
                        MediaQuery.of(context).size.width,
                        56,
                      ),
                      child: AppBar(
                        backgroundColor: ThemeData.dark().primaryColorDark,
                        //not on top of screen
                        primary: false,
                        //give the edit half life button space
                        centerTitle: false,
                        //medication name
                        title: Text(
                          "Fluvoxamine",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        //change half life name
                        actions: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            child: OutlineButton(
                              highlightedBorderColor: Theme.of(context).accentColor,
                              borderSide: BorderSide(
                                color: ThemeData.dark().cardColor,
                              ),
                              padding: EdgeInsets.all(0),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 12.0,
                                        right: 8,
                                      ),
                                      child: Text("36hrs"),
                                    ),
                                    Container(
                                      color: Theme.of(context).accentColor,
                                      height: 56.0 - (8 * 2),
                                      width: 36,
                                      padding: EdgeInsets.only(
                                        right: 12,
                                        left: 8,
                                      ),
                                      child: Transform.translate(
                                        offset: Offset(12.0, 4),
                                        child: DefaultTextStyle(
                                          style: TextStyle(
                                            color: ThemeData.dark().scaffoldBackgroundColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Transform.translate(
                                                offset: Offset(-12, -4),
                                                child: Text(
                                                  "t",
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                  ),
                                                ),
                                              ),
                                              Transform.translate(
                                                offset: Offset(0, 6),
                                                child: Stack(
                                                  children: [
                                                    Transform.translate(
                                                      offset: Offset(0, 0),
                                                      child: Text(
                                                        "1",
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, 0),
                                                      child: Text("_"),
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, 12),
                                                      child: Text("2"),
                                                    ),
                                                  ]
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                print("change active dose");
                              },
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
                        lastDateTime: lastDateTime,
                        screenWidth: MediaQuery.of(context).size.width,
                        halfLife: halfLife,
                        doses: doses,
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