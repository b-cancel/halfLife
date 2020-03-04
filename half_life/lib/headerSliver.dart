import 'package:flutter/material.dart';
import 'package:half_life/doseChart.dart';
import 'package:half_life/halfLifeChanger.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/struct/medication.dart';

class HeaderSliver extends StatefulWidget {
  const HeaderSliver({
    Key key,
    @required this.theSelectedDateTime,
    @required this.bottomBarHeight,
    @required this.chartHeight,
    @required this.statusBarHeight,
    @required this.lastDateTime,
    @required this.dosesVN,
  }) : super(key: key);

  final ValueNotifier<DateTime> theSelectedDateTime;
  final double bottomBarHeight;
  final double chartHeight;
  final double statusBarHeight;
  final ValueNotifier<DateTime> lastDateTime;
  final ValueNotifier<List<Dose>> dosesVN;

  @override
  _HeaderSliverState createState() => _HeaderSliverState();
}

class _HeaderSliverState extends State<HeaderSliver> {
  //eventually object updaters
  final TextEditingController textCtrl = new TextEditingController(text: "Fluvoxamine");

  final ValueNotifier<Duration> halfLife = ValueNotifier<Duration>(
    Duration(
      //36 to 60
      hours: 48,
    ),
  );

  //build
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
          widget.bottomBarHeight,
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
      expandedHeight: widget.chartHeight,
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
              height: widget.chartHeight,
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
                        56,
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
                              halfLife: halfLife,
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
                        halfLife: halfLife.value,
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