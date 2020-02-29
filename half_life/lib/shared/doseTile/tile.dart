import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:half_life/shared/tileDivider.dart';
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
                    leading: Theme(
                      data: Theme.of(context).copyWith(
                          iconTheme: IconThemeData(
                        color: ThemeData.dark().scaffoldBackgroundColor,
                      )),
                      child: ToTimeOfDay(
                        timeStamp: timeTaken,
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: ThemeData.dark().scaffoldBackgroundColor,
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
                      "On " +
                          DateTimeFormat.weekAndDay(
                            timeTaken,
                          ),
                    ),
                    trailing: Text(
                      dose.round().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class ToTimeOfDay extends StatelessWidget {
  ToTimeOfDay({
    @required this.timeStamp,
    this.addBack: true,
  });

  final DateTime timeStamp;
  final bool addBack;

  @override
  Widget build(BuildContext context) {
    //grab time stuff to then map it to icon
    int hour = timeStamp.hour; //0 to 23

    //mapping begin
    Widget icon;
    if (hour < 2) {
      //2 am
      icon = Icon(
        FontAwesome.moon_o,
      );
    } else if (hour < 5) {
      //5 am
      icon = Transform.translate(
        offset: Offset(1, -4),
        child: Icon(
          WeatherIcons.wi_moonset,
          color: Colors.white,
        ),
      );
    } else if (hour < 8) {
      icon = Transform.translate(
        offset: Offset(-3, -2),
        child: Icon(
          WeatherIcons.wi_sunrise,
        ),
      );
    } else if (hour < 17) {
      //same icon but shifted
      //shift when needed
      bool shiftLeft;
      if (hour < 11) {
        //shift right
        shiftLeft = false;
      } else if (hour < 14) {
      } else {
        //shift left
        shiftLeft = true;
      }

      //based on shift edit icon
      icon = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Container(
                height: 2,
                color: Colors.white,
              ),
            ),
          ),
          Icon(
            WeatherIcons.wi_day_sunny,
            color: Colors.transparent,
          ),
          Transform.translate(
            offset: Offset(
              shiftLeft == null ? 0 : (shiftLeft ? -6 : 6),
              shiftLeft == null ? -8 : -6,
            ),
            child: Icon(
              WeatherIcons.wi_day_sunny,
              size: 18,
            ),
          ),
        ],
      );
    } else if (hour < 20) {
      icon = Transform.translate(
        offset: Offset(-3, -2),
        child: Icon(
          WeatherIcons.wi_sunset,
        ),
      );
    } else if (hour < 23) {
      icon = Transform.translate(
        offset: Offset(1, -4),
        child: Icon(
          WeatherIcons.wi_moonrise,
        ),
      );
    } else {
      icon = Icon(
        FontAwesome.moon_o,
      );
    }

    //add proper background color
    if (addBack) {
      if (hour < 5) {
        icon = CircleAvatar(
          backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
          foregroundColor: Colors.white,
          child: icon,
        );
      } else if (hour < 8) {
        icon = CircleAvatar(
          backgroundColor: Color(0xFFffb347), //orange
          foregroundColor: ThemeData.dark().scaffoldBackgroundColor,
          child: icon,
        );
      } else if (hour < 17) {
        icon = CircleAvatar(
          backgroundColor: Color(0xFF4793ff), //blue
          foregroundColor: Colors.white,
          child: icon,
        );
      } else if (hour < 20) {
        icon = CircleAvatar(
          backgroundColor: Color(0xFFffb347), //orange
          foregroundColor: ThemeData.dark().scaffoldBackgroundColor,
          child: icon,
        );
      } else {
        icon = CircleAvatar(
          backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
          foregroundColor: Colors.white,
          child: icon,
        );
      }
    }

    //return icon
    return icon;
  }
}
