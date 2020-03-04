//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:half_life/struct/medication.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//internal
import 'package:half_life/utils/goldenRatio.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/headerSliver.dart';
import 'package:half_life/doseGroup.dart';

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
  final ValueNotifier<Duration> halfLife = new ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<List<Dose>> dosesVN = new ValueNotifier(new List<Dose>());
  final ValueNotifier<List<double>> activeDosesVN = new ValueNotifier(new List<double>());

  //-------------------------only allows one dose flyout to be open an once

  final ValueNotifier<bool> othersCloseOnToggle = new ValueNotifier<bool>(false);

  //-------------------------For Dose Selection (test autoscroll)

  final ValueNotifier<DateTime> theSelectedDateTime = new ValueNotifier<DateTime>(
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

  updateState(){
    updateGroups();
    if (mounted){
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

    //grab heights and all
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = 36;
    double screenHeight = MediaQuery.of(context).size.height;
    double chartHeight = measurementToGoldenRatioBS(screenHeight)[0];

    //create app bar
    Widget sliverAppBar = HeaderSliver(
      chartHeight: chartHeight, 
      statusBarHeight: statusBarHeight, 
      bottomBarHeight: bottomBarHeight, 
      lastDateTime: lastDateTime, 
      //updated when messing with sliver
      theSelectedDateTime: theSelectedDateTime,
      //data
      dosesVN: dosesVN,
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
    return Container(
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
    );
  }

  //dose groups
  List<List<Dose>> doseGroups;
  updateGroups() {
    //group doses into months (so we don't have to repeat it)
    //place month and year on sliver header
    if(doseGroups == null){
      doseGroups = new List<List<Dose>>();
    }
    else doseGroups.clear();

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
    List<double> newActiveDoses = new List<double>(dosesVN.value.length);
    if(dosesVN.value.length > 1){
      //set init values
      int lastDoseIndex = (dosesVN.value.length - 1);
      newActiveDoses[lastDoseIndex] = dosesVN.value[lastDoseIndex].value;
      
      //iterate through all other doses
      for(int i = (lastDoseIndex - 1); i >= 0; i--){
        //grab last data
        int lastIndex = i + 1;
        DateTime lastDoseTimestamp = dosesVN.value[lastIndex].timeStamp;
        double lastActiveDose = newActiveDoses[lastIndex];

        //grab this data
        Dose thisDose = dosesVN.value[i];
        double thisValue = thisDose.value;
        DateTime thisDoseTimestamp = thisDose.timeStamp;

        //determine what the acive dose is BEFORE us
        //this MUST BE before last
        Duration timeSinceTaken = thisDoseTimestamp.difference(lastDoseTimestamp);
        double decayConstant = math.log(2) / halfLife.value.inMicroseconds;
        double exponent = -decayConstant * timeSinceTaken.inMicroseconds;
        double dosageLeft = lastActiveDose * math.pow(math.e, exponent);

        //register the new doses active
        newActiveDoses[i] = dosageLeft + thisValue;

        double oldDose = newActiveDoses[i] - thisValue;
      }
    }
    activeDosesVN.value = newActiveDoses;
  }
}