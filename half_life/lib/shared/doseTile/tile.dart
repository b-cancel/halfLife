import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:half_life/shared/tileDivider.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/dateTimeFormat.dart';
import 'package:half_life/utils/durationFormat.dart';

class DoseTile extends StatelessWidget {
  const DoseTile({
    Key key,
    //relative to entire list
    @required this.isFirst,
    @required this.isLast,
    @required this.isEven,
    //color
    @required this.softHeaderColor,
    //values
    @required this.dose,
    @required this.timeTaken,
    @required this.timeSinceTaken,
  }) : super(key: key);

  final bool isFirst;
  final bool isLast;
  final bool isEven;
  final Color softHeaderColor;
  
  
  final double dose;
  final DateTime timeTaken;
  final Duration timeSinceTaken;

  @override
  Widget build(BuildContext context) {
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
                  : softHeaderColor,
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
                        dose.round().toString(),
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
                              timeSinceTaken,
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
                    subtitle: Text(
                      "On " + DateTimeFormat.weekAndDay(
                        timeTaken,
                      ),
                    )
                  ),
                  Visibility(
                    visible: isLast == false,
                    child: ListTileDivider(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
