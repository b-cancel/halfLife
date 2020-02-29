//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:half_life/items.dart';
import 'package:half_life/shared/scrollToTop.dart';
import 'package:half_life/shared/tileDivider.dart';
import 'package:half_life/utils/durationFormat.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:half_life/headerChart.dart';

//internal
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/goldenRatio.dart';

//widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Half Life',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<DateTime> lastDateTime =
      new ValueNotifier<DateTime>(DateTime.now());

  //settings that should eventually be changeable
  Duration halfLife = Duration(hours: 36);
  List<Dose> doses = new List<Dose>();
  int maxActiveDose = 40;

  final ScrollController scrollController = new ScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier(true);

  updateOnTopValue() {
    ScrollPosition position = scrollController.position;
    double currentOffset = scrollController.offset;

    //Determine whether we are on the top of the scroll area
    if (currentOffset <= position.minScrollExtent) {
      onTop.value = true;
    } else
      onTop.value = false;
  }

  @override
  void initState() {
    //show or hide the to top button
    scrollController.addListener(updateOnTopValue);

    doses.add(Dose(
        100,
        DateTime(
            2020,
            2, //feb
            20, //20
            1 //1 am
            )));

    doses.add(Dose(
        25,
        DateTime(
          2020,
          2,
          28,
          4,
        )));

    doses.add(Dose(
        50,
        DateTime(
            2020,
            2, //feb
            21, //21
            1 //1 am
            )));

    super.initState();
  }

  @override
  void dispose() {
    //remove listener
    scrollController.removeListener(updateOnTopValue);

    //super dispose
    super.dispose();
  }

  double sliderValue = 1;
  int dosesBeingConsidered;
  DateTime firstDose;
  Duration elapsedTime;

  /*
  calcActiveDose(){
    //sort our doses to our first dose is our first dose
    doses.sort((a, b) => b.compareTo(a));

    //grab our first dose
    firstDose = doses[0].timeStamp;

    //determine how much time has passed since our first dose
    Duration timeSinceFirst = DateTime.now().difference(firstDose);

    ///calculate the stuff we are showing the user
    elapsedTime = Duration(
      microseconds: (timeSinceFirst.inMicroseconds * sliderValue).round(),
    );
    lastDateTime = firstDose.add(elapsedTime);
    
    //loop through doses to calculate 
    //how much we have left of each after the selected time
    double totalDose = 0;
    dosesBeingConsidered = 0;
    for(int i = 0; i < doses.length; i++){
      bool doseBefore = doses[i].timeStamp.isBefore(lastDateTime);
      bool doseAt = doses[i].timeStamp.difference(lastDateTime) == Duration.zero;
      if(doseBefore || doseAt){
        dosesBeingConsidered++;

        double dose = doses[i].value;
        DateTime timeTaken = doses[i].timeStamp;
        Duration timeSinceTaken = lastDateTime.difference(timeTaken);

        //allways use duration in microseconds
        double decayConstant = math.log(2) / halfLife.inMicroseconds;
        double exponent = -decayConstant * timeSinceTaken.inMicroseconds;
        double dosageLeft = dose * math.pow(math.e, exponent);

        totalDose += dosageLeft;
      }
      //ELSE: we don't count it
    }

    return totalDose;
  }
  */

  //breifly show loading indicator for giggles
  Duration loadTime = Duration(seconds: 1);
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );

  updateDateTime() {
    lastDateTime.value = DateTime.now();
    if (mounted) setState(() {});
  }

  //runs on init to show user they can refresh
  //and
  void _onRefresh() async {
    updateDateTime();
    // monitor network fetch
    await Future.delayed(loadTime);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    updateDateTime();
    // monitor network fetch
    await Future.delayed(loadTime);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Color softHeader = Color(0xFF64ffda);

    //grab heights and all
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = 36;
    List<double> bigSmall =
        measurementToGoldenRatioBS(MediaQuery.of(context).size.height);

    //build
    return Scaffold(
      backgroundColor: softHeader,
      body: Stack(
        children: <Widget>[
          SmartRefresher(
            scrollController: scrollController,
            //no footer animation
            enablePullUp: false,
            //yes header animation
            enablePullDown: true,
            header: WaterDropMaterialHeader(
              offset: bigSmall[0],
              color: softHeader,
              backgroundColor: Colors.black,
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: softHeader,
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
                              icon: Icon(Icons.settings),
                              onPressed: () {
                                print("change active dose");
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                print("add dose");
                              },
                            ),
                          ]),
                    ),
                  ),
                  //most of the screen
                  expandedHeight: bigSmall[0],
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
                        Container(
                          height: bigSmall[0],
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: statusBarHeight,
                            bottom: bottomBarHeight,
                          ),
                          child: HeaderChart(
                            lastDateTime: lastDateTime,
                            screenWidth: MediaQuery.of(context).size.width,
                            halfLife: halfLife,
                            doses: doses,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              flex: smallNumber,
                              child: Container(),
                            ),
                            Text(
                              "AD",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Flexible(
                              flex: largeNumber,
                              child: Container(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SliverAnimatedList(
                  initialItemCount: doses.length,
                  itemBuilder: (BuildContext context, int index, anim) {
                    bool isEven = index % 2 == 0;
                    bool isFirst = index == 0;
                    bool isLast = index == doses.length - 1;
                    DateTime timeTaken = doses[index].timeStamp;
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      actions: <Widget>[
                        IconSlideAction(
                            caption: 'Archive',
                            color: Colors.blue,
                            icon: Icons.archive,
                            onTap: () {
                              print("more");
                            }),
                        IconSlideAction(
                            caption: 'Share',
                            color: Colors.indigo,
                            icon: Icons.share,
                            onTap: () {
                              print("more");
                            }),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: 'More',
                            color: Colors.black45,
                            icon: Icons.more_horiz,
                            onTap: () {
                              print("more");
                            }),
                        IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              print("delete");
                            }),
                      ],
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              color: isLast
                                  ? ThemeData.dark().scaffoldBackgroundColor
                                  : softHeader,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isFirst ? 24 : 0),
                              topRight: Radius.circular(isFirst ? 24 : 0),
                              bottomLeft: Radius.circular(isLast ? 24 : 0),
                              bottomRight: Radius.circular(isLast ? 24 : 0),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: isEven
                                          ? ThemeData.dark().cardColor
                                          : ThemeData.dark().primaryColorLight,
                                      child: Text(
                                        doses[index].value.round().toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      foregroundColor: Colors.white,
                                    ),
                                    title: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: ThemeData.dark()
                                              .scaffoldBackgroundColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Taken ",
                                          ),
                                          TextSpan(
                                            text: DurationFormat.format(
                                              lastDateTime.value
                                                  .difference(timeTaken),
                                              //settings
                                              len: 2,
                                              spaceBetween: true,
                                              //no big quants
                                              showYears: false,
                                              showMonths: false,
                                              showWeeks: false,
                                              //yes medium quants
                                              showDays: true,
                                              showHours: true,
                                              showMinutes: true,
                                              //no little quants
                                              showSeconds: false,
                                              showMilliseconds: false,
                                              showMicroseconds: false,
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " ago",
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  ListTileDivider(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SliverFillRemaining(
                  hasScrollBody: true, //it should be as small as possible
                  fillOverscroll: false, //only if above is false
                  child: Container(
                    color: ThemeData.dark().scaffoldBackgroundColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          FontAwesomeIcons.prescriptionBottle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ScrollToTopButton(
            onTop: onTop,
            color: softHeader,
            scrollController: scrollController,
          ),
        ],
      ),

      /*
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Your first dose was on: " + firstDose.toString()),
            Text("and after: " + elapsedTime.toString()),
            Text("on: " + lastDateTime.toString()),
            Text("you had only taken: " + dosesBeingConsidered.toString() + " doses"),
            Text("and your active dose was: " + activeDose.toString()),
            Text("Max Active Dose: " + maxActiveDose.toString()),
            Text("Max Dose To Take To Stay Below Max Active Dose"),
            Text(maxDose.toString()),
            Slider(
              min: 0,
              max: 1,
              value: sliderValue, 
              onChanged: (double newValue) {
                setState(() {
                  sliderValue = newValue;
                });
              },
            ),
          ],
        )
      ),
      */
    );
  }
}
