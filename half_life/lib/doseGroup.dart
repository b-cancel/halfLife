import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:half_life/shared/curvedCorner.dart';
import 'package:half_life/shared/doseTile/tile.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/dateTimeFormat.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

//everything
class DoseGroup extends StatelessWidget {
  DoseGroup({
    @required this.group,
    @required this.lastDateTime,
    @required this.theSelectedDateTime,
    @required this.autoScrollController,
  });

  final List<Dose> group;
  final ValueNotifier<DateTime> lastDateTime;
  final ValueNotifier<DateTime> theSelectedDateTime;
  final AutoScrollController autoScrollController;

  @override
  Widget build(BuildContext context) {
    //grab header info
    Dose firstDose = group[0];
    int groupMonth = firstDose.timeStamp.month;
    String monthString = DateTimeFormat.monthToString[groupMonth];

    //build
    return SliverStickyHeader(
      header: GroupHeader(
        month: monthString,
        year: firstDose.timeStamp.year.toString(),
      ),
      sliver: SliverAnimatedList(
        initialItemCount: group.length,
        itemBuilder: (BuildContext context, int index, anim) {
          DateTime timeTaken = group[index].timeStamp;
          return DoseTile(
            id: group[index].id,
            isFirst: index == 0,
            isLast: index == group.length - 1,
            isEven: index % 2 == 0,
            softHeaderColor: Theme.of(context).accentColor,
            dose: group[index].value,
            timeTaken: timeTaken,
            timeSinceTaken: lastDateTime.value.difference(timeTaken),
            theSelectedDateTime: theSelectedDateTime,
            autoScrollController: autoScrollController,
          );
        },
      ),
    );
  }
}

class GroupHeader extends StatelessWidget {
  const GroupHeader({
    Key key,
    @required this.month,
    @required this.year,
  }) : super(key: key);

  final String month;
  final String year;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ThemeData.dark().primaryColorDark;

    //build
    return Stack(
      children: <Widget>[
        Container(
          color: backgroundColor,
          padding: new EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          alignment: Alignment.bottomLeft,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              color: Colors.white, //TODO: maybe use soft header color?
              fontWeight: FontWeight.bold
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  month,
                ),
                Text(
                  year,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Transform.translate(
              offset: Offset(0, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CurvedCorner(
                    isTop: true, 
                    isLeft: true, 
                    cornerColor: backgroundColor,
                  ),
                  CurvedCorner(
                    isTop: true, 
                    isLeft: false, 
                    cornerColor: backgroundColor,
                  ),
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
}


      /*
      SliverList(
      delegate: new SliverChildListDelegate([
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: topColor,
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: bottomColor,
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: thisGroup.length,
                //ONLY false IF Hidden Section
                reverse: (sectionType != TimeStampType.Hidden),
                itemBuilder: (context, index){
                  AnExcercise excercise = thisGroup[index];
                  return ExcerciseTile(
                    key: ValueKey(excercise.id),
                    excercise: excercise,
                  );
                },
                separatorBuilder : (context, index) => ListTileDivider(),
              ),
            ),
          ],
        ),
      ]),
    )
      */