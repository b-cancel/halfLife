import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';

Future<DateTime> selectTimeDate(BuildContext context, DateTime initialDate) async {
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

  //updated by everything down the chain
  ValueNotifier<DateTime> selectedDate = new ValueNotifier<DateTime>(initialDate);

  //pick time
  TimeOfDay selectedTime = await showRoundedTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
    theme: themeForPopUps,
    barrierDismissible: false,
    borderRadius: 16,
    leftBtn: "Change Date",
    onLeftBtn: () async {
      DateTime datePicked = await showRoundedDatePicker(
        context: context,
        initialDate: selectedDate.value,
        theme: themeForPopUps,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
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
        barrierDismissible: false,
        borderRadius: 16,
      );

      //update the selected date
      if(datePicked != null){
        selectedDate.value = datePicked;
      }
    }
  );

  //if we didn't pick a time then sure we wont care to pick a day
  if(selectedTime != null){ //we selected a time
    //construct the new date time
    //may not include a date

    //date wasn't change
    if(selectedDate.value == initialDate){
      print("ONLY new time");
      return DateTime(
        //use last date
        initialDate.year,
        initialDate.month,
        initialDate.day,
        //use this time
        selectedTime.hour,
        selectedTime.minute,
      );
    } else {
      print("new Date AND Time");
      return DateTime(
        //use this date
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        //use this time
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  } //use last date and time
  else return initialDate;
}
