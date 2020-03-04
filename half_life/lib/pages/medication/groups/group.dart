//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_villains/villain.dart';

//internal
import 'package:half_life/pages/medication/groups/header.dart';
import 'package:half_life/pages/medication/item/tile.dart';
import 'package:half_life/utils/dateTimeFormat.dart';
import 'package:half_life/struct/doses.dart';

//widget
class DoseGroup extends StatelessWidget {
  DoseGroup({
    //open close
    @required this.otherCloseOnToggle,
    @required this.autoScrollController,
    //inner
    @required this.lastDateTime,
    @required this.theSelectedDateTime,
    @required this.lastGroup,
    @required this.doseIDtoActiveDoseVN,
    @required this.group,
  });

  //open close
  final ValueNotifier<bool> otherCloseOnToggle;
  final AutoScrollController autoScrollController;
  //inner
  final ValueNotifier<DateTime> lastDateTime;
  final ValueNotifier<DateTime> theSelectedDateTime;
  final ValueNotifier<Map<int, double>> doseIDtoActiveDoseVN;
  final List<Dose> group;
  final bool lastGroup;

  //build
  @override
  Widget build(BuildContext context) {
    //grab header info
    Dose firstDose = group[0];
    int groupMonth = firstDose.timeStamp.month;
    String monthString = DateTimeFormat.monthToString[groupMonth];

    //build
    return SliverStickyHeader(
      header: Villain(
        animateEntrance: true,
        animateReEntrance: true,
        animateExit: true,
        villainAnimation: VillainAnimation.fromBottom(
          relativeOffset: .5,
        ),
        secondaryVillainAnimation: VillainAnimation.fade(),
        child: GroupHeader(
          month: monthString,
          year: firstDose.timeStamp.year.toString(),
        ),
      ),
      sliver: SliverAnimatedList(
        initialItemCount: group.length,
        itemBuilder: (BuildContext context, int index, anim) {
          //ease access vars
          Dose thisDose = group[index];
          int doseID = thisDose.id;
          DateTime timeTaken = thisDose.timeStamp;

          //build
          return Villain(
            animateEntrance: true,
            animateReEntrance: true,
            animateExit: true,
            villainAnimation: VillainAnimation.fromBottom(
              relativeOffset: .5,
            ),
            secondaryVillainAnimation: VillainAnimation.fade(),
            child: Stack(
              children: <Widget>[
                //for absolute last group
                //the corner that are uncovered should match the filler sliver
                Positioned.fill(
                  child: Column(
                    children: [
                      //the top part of perhaps just ONE doseage
                      Expanded(child: Container()),
                      Expanded(
                        child: Container(
                          color: lastGroup
                              ? ThemeData.dark().scaffoldBackgroundColor
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                //the tile
                DoseTile(
                  id: doseID,
                  isFirst: index == 0,
                  isLast: index == group.length - 1,
                  isEven: index % 2 == 0,
                  softHeaderColor: Theme.of(context).accentColor,
                  dose: thisDose.value,
                  activeDose: doseIDtoActiveDoseVN.value[doseID],
                  timeTaken: timeTaken,
                  timeSinceTaken: lastDateTime.value.difference(timeTaken),
                  theSelectedDateTime: theSelectedDateTime,
                  autoScrollController: autoScrollController,
                  othersCloseOnToggle: otherCloseOnToggle,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}