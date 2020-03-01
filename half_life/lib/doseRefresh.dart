//flutter
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:half_life/main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//internal
import 'package:half_life/utils/goldenRatio.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/doseChart.dart';
import 'package:half_life/doseGroup.dart';

//handle pull to refresh
class DosesRefresh extends StatefulWidget {
  DosesRefresh({
    @required this.scrollController,
    @required this.halfLife,
    @required this.doses,
  });

  final ScrollController scrollController;
  final Duration halfLife;
  final List<Dose> doses;

  @override
  _DosesRefreshState createState() => _DosesRefreshState();
}

class _DosesRefreshState extends State<DosesRefresh> {
  //atleast give people a second to realize what they did
  Duration loadTime = Duration(seconds: 1);

  //alot of things rely on this so we make it manually reloadable
  final ValueNotifier<DateTime> lastDateTime = new ValueNotifier<DateTime>(
    DateTime.now(),
  );

  //controlls liquid refresh
  RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );

  //everything updated at once
  updateDateTime() {
    lastDateTime.value = DateTime.now();
    updateSlivers();
    if (mounted) setState(() {});
  }

  //update before settings state
  double chartHeight;
  List<Widget> slivers;
  updateSlivers() {
    //the doses that we just took go on top
    widget.doses.sort((a, b) => a.compareTo(b));

    //group doses into months (so we don't have to repeat it)
    //place month and year on sliver header
    List<List<Dose>> doseGroups = new List<List<Dose>>();

    //NOTE: must use month AND year to be safe
    int doseMonth = -1;
    int doseYear = -1;

    //create groups
    for (int i = 0; i < widget.doses.length; i++) {
      //extract dose properties
      Dose thisDose = widget.doses[i];
      int thisMonth = thisDose.timeStamp.month;
      int thisYear = thisDose.timeStamp.year;
      bool sameMonth = thisMonth == doseMonth;
      bool sameYear = thisYear == doseYear;
      bool sameGroup = sameMonth && sameYear;

      //If we are not in the same group
      if (sameGroup == false) {
        //start new group
        doseGroups.add(new List<Dose>());
        doseMonth = thisMonth;
        doseYear = thisYear;
      }

      //add dose to last group
      doseGroups.last.add(thisDose);
    }

    //grab heights and all
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = 36;
    double screenHeight = MediaQuery.of(context).size.height;
    chartHeight = measurementToGoldenRatioBS(screenHeight)[0];

    //create app bar
    Widget sliverAppBar = SliverAppBar(
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
                        halfLife: widget.halfLife,
                        doses: widget.doses,
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

    //generate group widgets
    List<Widget> groups = new List<Widget>();
    for (int i = 0; i < doseGroups.length; i++) {
      groups.add(
        DoseGroup(
          group: doseGroups[i],
          lastDateTime: lastDateTime,
        ),
      );
    }

    //fill space
    Widget fillRemainingSliver = SliverFillRemaining(
      hasScrollBody: false, //it should be as small as possible
      fillOverscroll: true, //only if above is false
      child: Container(
        color: ThemeData.dark().scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Icon(
              FontAwesomeIcons.prescriptionBottle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    //add slivers one by one
    slivers?.clear();
    slivers = new List<Widget>();
    slivers.add(sliverAppBar);
    slivers.addAll(groups);
    slivers.add(fillRemainingSliver);
  }

  //build
  @override
  Widget build(BuildContext context) {
    if (slivers == null) {
      updateSlivers();
    }

    //build
    return SmartRefresher(
      physics: BouncingScrollPhysics(),
      scrollController: widget.scrollController,
      //no footer animation
      enablePullUp: false,
      //yes header animation
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        offset: chartHeight,
        color: ThemeData.dark().scaffoldBackgroundColor,
      ),
      controller: refreshController,
      onRefresh: () async {
        updateDateTime();
        // monitor network fetch
        await Future.delayed(loadTime);
        // if failed,use refreshFailed()
        refreshController.refreshCompleted();
      },
      onLoading: () async {
        updateDateTime();
        // monitor network fetch
        await Future.delayed(loadTime);
        // if failed,use loadFailed(),if no data return,use LoadNodata()
        refreshController.loadComplete();
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: widget.scrollController,
        slivers: slivers,
      ),
    );
  }
}
