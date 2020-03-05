//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:half_life/pages/medication/item/delete.dart';
import 'package:half_life/shared/selectTimeDate.dart';
import 'package:half_life/utils/dateTimeFormat.dart';

//widget
class Options extends StatelessWidget {
  const Options({
    Key key,
    @required this.dose,
    @required this.initialDate,
    @required this.isLast,
  }) : super(key: key);

  final double dose;
  final DateTime initialDate;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isLast ? ThemeData.dark().primaryColorDark : Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Material(
          color: ThemeData.dark().cardColor,
          child: Container(
            height: 72,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pills,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      print("change dosage");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Container(
                    color: ThemeData.dark().primaryColorLight,
                    width: 1,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DateTime newDT =
                          await selectTimeDate(context, initialDate);
                      print("***********new date time: " + newDT.toString());
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Container(
                    color: ThemeData.dark().primaryColorLight,
                    width: 1,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 36,
                    ),
                    onPressed: () async {
                      deleteDose(context, dose, initialDate);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeekDayYear extends StatelessWidget {
  const WeekDayYear({
    Key key,
    @required this.dateTime,
    this.showYear: false,
  }) : super(key: key);

  final DateTime dateTime;
  final bool showYear;

  @override
  Widget build(BuildContext context) {
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    //build
    return RichText(
      text: TextSpan(
          style: TextStyle(
            color: ThemeData.dark().scaffoldBackgroundColor,
            fontSize: showYear ? null : 16,
          ),
          children: [
            TextSpan(
              text: DateTimeFormat.weekDayToString[dateTime.weekday],
              style: bold,
            ),
            TextSpan(
              text: " the ",
            ),
            TextSpan(
              text: dateTime.day.toString(),
              style: bold,
            ),
            TextSpan(
              text: DateTimeFormat.daySuffix(
                dateTime.day,
              ),
            ),
            TextSpan(
              text: showYear ? ", " : "",
            ),
            TextSpan(
              text: showYear ? dateTime.year.toString() : "",
              style: bold,
            ),
          ]),
    );
  }
}
