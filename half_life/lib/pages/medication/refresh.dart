//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//internal
import 'package:half_life/pages/medication/groups/group.dart';
import 'package:half_life/pages/medication/header.dart';
import 'package:half_life/struct/medication.dart';
import 'package:half_life/utils/goldenRatio.dart';
import 'package:half_life/struct/doses.dart';

//handle pull to refresh
class RefreshPage extends StatefulWidget {
  RefreshPage({
    @required this.autoScrollController,
    @required this.medication,
  });

  final AutoScrollController autoScrollController;
  final AMedication medication;

  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  final ValueNotifier<Duration> halfLife =
      new ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<List<Dose>> dosesVN = new ValueNotifier(new List<Dose>());
  final ValueNotifier<Map<int, double>> doseIDtoActiveDoseVN =
      new ValueNotifier(Map<int, double>());

  //-------------------------only allows one dose flyout to be open an once

  final ValueNotifier<bool> othersCloseOnToggle =
      new ValueNotifier<bool>(false);

  //-------------------------For Dose Selection (test autoscroll)

  final ValueNotifier<DateTime> theSelectedDateTime =
      new ValueNotifier<DateTime>(
    DateTime.now(), //immediately overriden
  );

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
    updateState();
  }

  updateState() {
    updateGroups();
    if (mounted) {
      setState(() {});
    }
  }

  //-------------------------Init / Dispose

  @override
  void initState() {
    //super init
    super.initState();

    //initially select DT is now
    theSelectedDateTime.value = lastDateTime.value;

    //fill notifier and listen to changes to update stuff
    dosesVN.value = widget.medication.doses;
    dosesVN.addListener(updateState);

    //ditto for half life
    halfLife.value = widget.medication.halfLife;
    halfLife.addListener(updateState);
  }

  @override
  void dispose() {
    dosesVN.removeListener(updateState);
    halfLife.removeListener(updateState);
    super.dispose();
  }

  //-------------------------Widget Builders

  //build
  @override
  Widget build(BuildContext context) {
    if (doseGroups == null) {
      updateGroups();
    }

    //grab status bar height (changes on orientation and platform)
    double statusBarHeight = MediaQuery.of(context).padding.top;
    //standard app bar height according to fluter
    double appBarHeight = 56;
    //the size that felt right
    double bottomBarHeight = 36;
    //entire screen height (Excludes on screen buttons)
    double screenHeight = MediaQuery.of(context).size.height;
    //min body height so we can be as close as possible to golden ratio porportions
    //without causing a break in functionality
    double sectionHeaderSize = 43; //obtained manually
    double tileHeight = 72; //obtained manually
    double minBodyHeight = sectionHeaderSize + tileHeight + (tileHeight / 2);
    double maxChartHeight =
        screenHeight - statusBarHeight - appBarHeight - minBodyHeight;

    //calc chartHeight
    double chartHeight = measurementToGoldenRatioBS(screenHeight)[0];
    chartHeight = (chartHeight > maxChartHeight) ? maxChartHeight : chartHeight;

    //create app bar
    Widget sliverAppBar = HeaderSliver(
      //heights and such
      statusBarHeight: statusBarHeight,
      appBarHeight: appBarHeight,
      accentHeight: chartHeight,
      bottomBarHeight: bottomBarHeight,
      //other
      lastDateTime: lastDateTime,
      //updated when messing with sliver
      theSelectedDateTime: theSelectedDateTime,
      //data
      dosesVN: dosesVN,
      doseIDtoActiveDoseVN: doseIDtoActiveDoseVN,
      halfLife: halfLife,
    );

    //generate group widgets
    List<Widget> groups = new List<Widget>();
    for (int i = 0; i < doseGroups.length; i++) {
      groups.add(
        DoseGroup(
          group: doseGroups[i],
          doseIDtoActiveDoseVN: doseIDtoActiveDoseVN,
          lastGroup: i == (doseGroups.length - 1),
          theSelectedDateTime: theSelectedDateTime,
          lastDateTime: lastDateTime,
          otherCloseOnToggle: othersCloseOnToggle,
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
    return Stack(
      children: <Widget>[
        Container(
          color: ThemeData.dark().primaryColorDark,
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
        Visibility(
          visible: false,
          child: OriginalGoldenRatioGuide(
            statusBarHeight: statusBarHeight,
            appBarHeight: appBarHeight,
            chartHeight: chartHeight,
          ),
        ),
      ],
    );
  }

  //dose groups
  List<List<Dose>> doseGroups;
  updateGroups() {
    //group doses into months (so we don't have to repeat it)
    //place month and year on sliver header
    if (doseGroups == null) {
      doseGroups = new List<List<Dose>>();
    } else
      doseGroups.clear();

    //the doses that we just took go on top
    dosesVN.value.sort((a, b) => a.compareTo(b));

    //NOTE: must use month AND year to be safe
    int doseMonth = -1;
    int doseYear = -1;

    //create groups
    for (int i = 0; i < dosesVN.value.length; i++) {
      //extract dose properties
      Dose thisDose = dosesVN.value[i];
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

    //calculate how the active dose after every dose
    Map<int, double> doseIDtoActiveDose = new Map<int, double>();
    if (dosesVN.value.length > 0) {
      //set first dose that doesn't rely on any other dose
      //first dose is going to be at the end of the list
      int firstDoseIndex = (dosesVN.value.length - 1);
      Dose firstDose = dosesVN.value[firstDoseIndex];
      doseIDtoActiveDose[firstDose.id] = firstDose.value;

      //iterate through all other doses
      for (int doseIndex = (firstDoseIndex - 1); doseIndex >= 0; doseIndex--) {
        //grab last data
        int prevIndex = doseIndex + 1;
        Dose prevDose = dosesVN.value[prevIndex];
        DateTime prevTimestamp = prevDose.timeStamp;
        double prevActiveDose = doseIDtoActiveDose[prevDose.id];

        //grab this data
        Dose currDose = dosesVN.value[doseIndex];
        double thisValue = currDose.value;
        DateTime thisDoseTimestamp = currDose.timeStamp;

        //determine what the acive dose is BEFORE us
        //this MUST BE before last
        Duration timeSinceTaken = thisDoseTimestamp.difference(prevTimestamp);
        double decayConstant = math.log(2) / halfLife.value.inMicroseconds;
        double exponent = -decayConstant * timeSinceTaken.inMicroseconds;
        double dosageLeft = prevActiveDose * math.pow(math.e, exponent);

        //register the new doses active
        doseIDtoActiveDose[currDose.id] = dosageLeft + thisValue;
      }
    }
    doseIDtoActiveDoseVN.value = doseIDtoActiveDose;
  }
}

class OriginalGoldenRatioGuide extends StatelessWidget {
  const OriginalGoldenRatioGuide({
    Key key,
    @required this.statusBarHeight,
    @required this.appBarHeight,
    @required this.chartHeight,
  }) : super(key: key);

  final double statusBarHeight;
  final double appBarHeight;
  final double chartHeight;

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: 0.5,
        child: Column(children: [
          Container(
            height: statusBarHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
          ),
          Container(
            height: appBarHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
          ),
          Container(
            height: chartHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
          ),
        ]));
  }
}
