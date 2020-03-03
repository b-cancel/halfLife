import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:half_life/shared/playOnceGif.dart';

class Options extends StatelessWidget {
  const Options({
    Key key,
    @required this.initialDate,
    @required this.isLast,
  }) : super(key: key);

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
                      //just to comply with material color standards I guess
                      Map<int, Color> color = {
                        50: Color.fromRGBO(30, 30, 30, 1),
                        100: Color.fromRGBO(30, 30, 30, 1),
                        200: Color.fromRGBO(30, 30, 30, 1),
                        300: Color.fromRGBO(30, 30, 30, 1),
                        400: Color.fromRGBO(30, 30, 30, 1),
                        500: Color.fromRGBO(30, 30, 30, 1),
                        600: Color.fromRGBO(30, 30, 30, 1),
                        700: Color.fromRGBO(30, 30, 30, 1),
                        800: Color.fromRGBO(30, 30, 30, 1),
                        900: Color.fromRGBO(30, 30, 30, 1),
                      };

                      //the theme for both pop ups
                      ThemeData themeForPopUps = ThemeData(
                        //color of buttons
                        //A.K.A. ThemeData.dark().scaffoldBackgroundColor,
                        //A.K.A. Color(0xFF303030),
                        primarySwatch: MaterialColor(0xFF303030, color),
                        //circle highlight
                        accentColor: Theme.of(context).accentColor,
                        //banner color
                        primaryColor: ThemeData.dark().scaffoldBackgroundColor,
                        //color of text inside circle highlight
                        accentTextTheme: TextTheme(
                          bodyText1: TextStyle(
                            color: ThemeData.dark().scaffoldBackgroundColor,
                          ),
                        ),
                      );

                      //pick day
                      DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: initialDate,
                        theme: themeForPopUps,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime.now(),
                        initialDatePickerMode: DatePickerMode.day,
                        styleYearPicker: MaterialRoundedYearPickerStyle(
                          textStyleYearSelected: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemeData.dark().primaryColorDark,
                            fontSize: 36,
                          ),
                          textStyleYear: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: ThemeData.dark().primaryColorLight,
                            fontSize: 24,
                          ),
                        ),
                        description: "When Was The Dose Taken",
                        barrierDismissible: true,
                        borderRadius: 16,
                      );

                      //pick time of day
                      if (newDateTime != null) {
                        TimeOfDay time = await showRoundedTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(newDateTime),
                          theme: themeForPopUps,
                          barrierDismissible: true,
                          borderRadius: 16,
                        );
                      }
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
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            contentPadding: EdgeInsets.all(0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(12.0),
                                      topRight: const Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 36,
                                      top: 24,
                                    ),
                                    child: Container(
                                      height: 140,
                                      child: PlayGifOnce(
                                        assetName: "assets/delete.gif",
                                        runTimeMS: 6120,
                                        frameCount: 98,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Colors.black,
                                      ),
                                      child: Text("Delete Dose?"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text("message"),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Don't Delete",
                                  style: TextStyle(
                                    color: ThemeData.dark().scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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
