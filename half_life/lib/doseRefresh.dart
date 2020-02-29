import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:half_life/doseChart.dart';
import 'package:half_life/shared/doseTile/tile.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/goldenRatio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
SliverStickyHeader(
            header: SectionHeader(
              title: title, 
              subtitle: subtitle, 
              sectionType: sectionType, 
              highlightTop: highlightTop,
              topColor: topColor,
            ),
            sliver: SectionBody(
              topColor: topColor, 
              bottomColor: bottomColor, 
              thisGroup: thisGroup, 
              sectionType: sectionType,
            ),
          ),
*/

class DosesRefresh extends StatefulWidget {
  DosesRefresh({
    @required this.softHeaderColor,
    @required this.scrollController,
    @required this.halfLife,
    @required this.doses,
  });

  final Color softHeaderColor;
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

  updateDateTime() {
    lastDateTime.value = DateTime.now();
    if (mounted) setState(() {});
  }

  void onRefresh() async {
    updateDateTime();
    // monitor network fetch
    await Future.delayed(loadTime);
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    updateDateTime();
    // monitor network fetch
    await Future.delayed(loadTime);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    //grab heights and all
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = 36;
    double screenHeight = MediaQuery.of(context).size.height;
    List<double> bigSmall = measurementToGoldenRatioBS(screenHeight);

    //refreshable body
    return SmartRefresher(
      scrollController: widget.scrollController,
      //no footer animation
      enablePullUp: false,
      //yes header animation
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        offset: bigSmall[0],
        color: widget.softHeaderColor,
        backgroundColor: Colors.black,
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: widget.softHeaderColor,
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
                      halfLife: widget.halfLife,
                      doses: widget.doses,
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
            initialItemCount: widget.doses.length,
            itemBuilder: (BuildContext context, int index, anim) {
              DateTime timeTaken = widget.doses[index].timeStamp;
              return DoseTile(
                isFirst: index == 0,
                isLast: index == widget.doses.length - 1,
                isEven: index % 2 == 0,
                softHeaderColor: widget.softHeaderColor,
                dose: widget.doses[index].value,
                timeTaken: timeTaken,
                timeSinceTaken: lastDateTime.value.difference(timeTaken),
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
    );
  }
}
