import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    onPressed: ()async{
                      //just to comply with material color standards I guess
                      Map<int, Color> color = {
                      50: Color.fromRGBO(30,30,30, 1),
                      100:Color.fromRGBO(30,30,30, 1),
                      200:Color.fromRGBO(30,30,30, 1),
                      300:Color.fromRGBO(30,30,30, 1),
                      400:Color.fromRGBO(30,30,30, 1),
                      500:Color.fromRGBO(30,30,30, 1),
                      600:Color.fromRGBO(30,30,30, 1),
                      700:Color.fromRGBO(30,30,30, 1),
                      800:Color.fromRGBO(30,30,30, 1),
                      900:Color.fromRGBO(30,30,30, 1),
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
                        initialDatePickerMode: DatePickerMode.year,
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
                      if(newDateTime != null){
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
                    onPressed: ()async{
                      
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