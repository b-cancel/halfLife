//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//internal
import 'package:half_life/utils/goldenRatio.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/headerSliver.dart';
import 'package:half_life/doseGroup.dart';

//handle pull to refresh
class DosesRefresh extends StatefulWidget {
  DosesRefresh({
    @required this.autoScrollController,
    @required this.halfLife,
    @required this.doses,
  });

  final AutoScrollController autoScrollController;
  final Duration halfLife;
  final List<Dose> doses;

  @override
  _DosesRefreshState createState() => _DosesRefreshState();
}

class _DosesRefreshState extends State<DosesRefresh> {
  final ValueNotifier<DateTime> theSelectedDateTime = new ValueNotifier<DateTime>(
    DateTime.now(), //immediately overriden
  );
  
  @override
  void initState() { 
    //super init
    super.initState();

    //initially select DT is now
    theSelectedDateTime.value = lastDateTime.value;
    //selectDateTime.addListener(() { })
  }

  //-------------------------Refresh Code

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
    updateGroups();
    if (mounted) setState(() {});
  }

  //-------------------------Widget Builders

  //build
  @override
  Widget build(BuildContext context) {
    if (doseGroups == null) {
      updateGroups();
    }

    //grab heights and all
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = 36;
    double screenHeight = MediaQuery.of(context).size.height;
    chartHeight = measurementToGoldenRatioBS(screenHeight)[0];

    //create app bar
    Widget sliverAppBar = HeaderSliver(
      theSelectedDateTime: theSelectedDateTime,
      bottomBarHeight: bottomBarHeight, 
      chartHeight: chartHeight, 
      statusBarHeight: statusBarHeight, 
      lastDateTime: lastDateTime, 
      doses: widget.doses,
      halfLife: widget.halfLife,
    );

    //generate group widgets
    List<Widget> groups = new List<Widget>();
    for (int i = 0; i < doseGroups.length; i++) {
      groups.add(
        DoseGroup(
          group: doseGroups[i],
          lastGroup: i == (doseGroups.length - 1),
          theSelectedDateTime: theSelectedDateTime,
          lastDateTime: lastDateTime,
          autoScrollController: widget.autoScrollController,
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

    //sliver
    List<Widget> slivers = new List<Widget>();
    slivers.add(sliverAppBar);
    slivers.addAll(groups);
    slivers.add(fillRemainingSliver);

    //build
    return Container(
      color: ThemeData.dark().primaryColorDark,
      child: AnimationLimiter(
        child: SmartRefresher(
          scrollController: widget.autoScrollController,
          physics: BouncingScrollPhysics(),
          //no footer animation
          enablePullUp: false,
          //yes header animation
          enablePullDown: true,
          header: WaterDropMaterialHeader(
            offset: chartHeight,
            backgroundColor: Theme.of(context).accentColor,
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
            controller: widget.autoScrollController,
            slivers: slivers,
          ),
        ),
      ),
    );
  }

  //update before settings state
  //seperated from build to stop unecesary reloads
  double chartHeight;
  List<List<Dose>> doseGroups;
  updateGroups() {
    //group doses into months (so we don't have to repeat it)
    //place month and year on sliver header
    if(doseGroups == null){
      doseGroups = new List<List<Dose>>();
    }
    else doseGroups.clear();

    //the doses that we just took go on top
    widget.doses.sort((a, b) => a.compareTo(b));

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
  }
}