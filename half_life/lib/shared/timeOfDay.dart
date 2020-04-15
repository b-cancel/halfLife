import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:half_life/pages/medication/add/field.dart';

class ToTimeOfDay extends StatelessWidget {
  ToTimeOfDay({
    @required this.timeStamp,
    this.popUpToRight: true,
  });

  final DateTime timeStamp;
  final bool popUpToRight;

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

    //return icon
    return IconButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        BotToast.showAttachedWidget(
          targetContext: context,
          onlyOne: true,
          allowClick: true,
          enableSafeArea: true,
          preferDirection: popUpToRight
              ? PreferDirection.rightCenter
              : PreferDirection.bottomCenter,
          horizontalOffset: popUpToRight ? 12 : 0,
          verticalOffset: popUpToRight ? 0 : 12,
          duration: Duration(seconds: 5),
          attachedBuilder: (_) => Theme(
            data: ThemeData.dark(),
            child: GestureDetector(
              onTap: () => BotToast.cleanAll(),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: popUpToRight
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      DaysAgo(
                        dateTime: timeStamp,
                      ),
                      TimeThatDay(
                        dateTime: timeStamp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      icon: icon,
      iconSize: 24,
    );
  }
}
