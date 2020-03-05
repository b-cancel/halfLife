import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:half_life/pages/medication/item/options.dart';
import 'package:half_life/shared/selectTimeDate.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/dateTimeFormat.dart';

class AddDoseField extends StatefulWidget {
  const AddDoseField({
    Key key,
    @required this.pillSize,
    @required this.addingDose,
    @required this.dosesVN,
  }) : super(key: key);

  final double pillSize;
  final ValueNotifier<bool> addingDose;
  final ValueNotifier<List<Dose>> dosesVN;

  @override
  _AddDoseFieldState createState() => _AddDoseFieldState();
}

class _AddDoseFieldState extends State<AddDoseField> {
  final FocusNode focusNode = new FocusNode();
  final TextEditingController newDoseController = new TextEditingController();
  final ValueNotifier<DateTime> newDateTime =
      new ValueNotifier<DateTime>(DateTime.now());

  updateState() {
    if (mounted) {
      //grab or "reset" date time
      newDateTime.value = DateTime.now();

      //we don't want to add it or already did
      if (widget.addingDose.value == false) {
        FocusScope.of(context).unfocus();
      } else {
        //clear data
        newDoseController.clear();

        //focus on the field
        FocusScope.of(context).requestFocus(focusNode);
      }

      //show changes
      setState(() {});
    }
  }

  saveDose() {
    /*
    //find next ID
    int largestID = 0;
    for(int i = 0; i < widget.dosesVN.value.length; i++){
      int thisID = widget.dosesVN.value[i].id;
      if(thisID > largestID){
        largestID = thisID;
      }
    }

    //create new list of doses (with space for new dose)
    List<Dose> oldDoses = widget.dosesVN.value;
    List<Dose> newDoses = new List<Dose>(oldDoses.length + 1);
    for(int i = 0; i < oldDoses.length; i++){
      newDoses[i] = oldDoses[i];
    }

    //create dose
    int newID = largestID + 1;
    String newValue = newDoseController.text;
    newValue = (newValue.length == 0) ? "0" : newValue;
    Dose theNewDose = Dose(
      newID,
      int.parse(newValue).toDouble(),
      DateTime.now(),
    );

    
    //DONT use add it messes up on fixed length lits
    newDoses[oldDoses.length] = theNewDose;

    //notify everything
    widget.dosesVN.value = newDoses;
    */

    //close ourselves
    widget.addingDose.value = false;
  }

  @override
  void initState() {
    super.initState();
    widget.addingDose.addListener(updateState);
  }

  @override
  void dispose() {
    widget.addingDose.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ThemeData.dark().primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.pillSize / 3),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: widget.addingDose.value ? widget.pillSize : 0,
              color: ThemeData.dark().cardColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: (widget.pillSize - (16 * 2)) * (4 / 4),
                            height: widget.pillSize - (16 * 2),
                            decoration: BoxDecoration(
                              //between 500 and 800
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: widget.pillSize - (16 * 2),
                                  color: Theme.of(context).accentColor,
                                ),
                                TextField(
                                  focusNode: focusNode,
                                  controller: newDoseController,
                                  //only difference when scroll to field
                                  scrollPadding: EdgeInsets.only(
                                    bottom: widget.pillSize,
                                  ),
                                  //style of text typed
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: widget.pillSize / 3,
                                  ),
                                  cursorColor:
                                      ThemeData.dark().scaffoldBackgroundColor,
                                  //eliminate bottom line border
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 14,
                                      bottom: (widget.pillSize / 3) / 2,
                                    ),
                                    suffix: Transform.translate(
                                      offset: Offset(-2, 4),
                                      child: Text(
                                        "u",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  //hide signs or decimals from keyboard if possible
                                  keyboardType: TextInputType.numberWithOptions(
                                    signed: false,
                                    decimal: false,
                                  ),
                                  //balance
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  //super guarantee only digits
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  //only 1 line at all times
                                  expands: false,
                                  minLines: 1,
                                  maxLines: 1,
                                  //on complete
                                  //onEditingComplete: () => saveDose(),
                                  onSubmitted: (str) => saveDose(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: (widget.pillSize - (16 * 2)) * (4 / 4),
                            height: widget.pillSize - (16 * 2),
                            decoration: BoxDecoration(
                              //between 500 and 800
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeData.dark().primaryColorLight,
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                      height: widget.pillSize,
                      width: 4,
                    ),
                  ),
                  Expanded(
                    child: DateTimeSelector(
                      newDateTime: newDateTime,
                    ),
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

class DateTimeSelector extends StatefulWidget {
  const DateTimeSelector({
    Key key,
    @required this.newDateTime,
  }) : super(key: key);

  final ValueNotifier<DateTime> newDateTime;

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.newDateTime.addListener(updateState);
  }

  @override
  void dispose() {
    widget.newDateTime.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime displayDT = widget.newDateTime.value;
    int hourAdjusted = displayDT.hour;
    bool isAM = hourAdjusted < 12;
    if(isAM){
      if(hourAdjusted == 0){
        hourAdjusted = 12;
      }
    }
    else{
      if(hourAdjusted != 12){
        hourAdjusted -= 12;
      }
    }
    int minute = displayDT.minute;
    int zerosToAdd = 2 - minute.toString().length;
    String zeros = (zerosToAdd == 0) ? "" : (zerosToAdd == 1 ? "0" : "00");

    //styling
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    //build
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          DateTime newDT = await selectTimeDate(
            context,
            displayDT,
          );

          if (newDT != null) {
            widget.newDateTime.value = newDT;
          }
        },
        child: Container(
          height: 72,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: 8.0,
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                DaysAgo(
                  dateTime: displayDT,
                ),
                RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "On ",
                          ),
                          TextSpan(
                            text: DateTimeFormat.weekDayToString[displayDT.weekday],
                            style: bold,
                          ),
                          TextSpan(
                            text: " the",
                          ),
                        ],
                      ),
                    ),
                RichText(
                  text: TextSpan(
                    children: [
                      
                      TextSpan(
                        text: displayDT.day.toString(),
                        style: bold,
                      ),
                      TextSpan(
                        text: DateTimeFormat.daySuffix(
                          displayDT.day,
                        ),
                      ),
                      TextSpan(
                        text: " of ",
                      ),
                      TextSpan(
                        text: DateTimeFormat.monthToStringShort[
                          displayDT.month
                        ],
                        style: bold,
                      ),
                      TextSpan(
                        text: ", ",
                      ),
                      TextSpan(
                        text: displayDT.year.toString(),
                        style: bold,
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "at ",
                      ),
                      TextSpan(
                        text:  hourAdjusted.toString() 
                        + ":" 
                        + zeros
                        + minute.toString(),
                        style: bold,
                      ),
                      TextSpan(
                        text: isAM ? " am" : " pm",
                      ),
                    ],
                  ),
                ),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}

class DaysAgo extends StatelessWidget {
  DaysAgo({
    @required this.dateTime,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    int daysAgo = 0;
    DateTime now = DateTime.now();
    Duration d = now.difference(dateTime);
    daysAgo = d.inDays;
    if (daysAgo == 0) {
      //24 hours may not have passed but it still may be a different day
      bool differentDay = now.day != dateTime.day;
      daysAgo = differentDay ? 1 : 0;
    }

    //build if days have passed
    return Visibility(
      visible: daysAgo > 0,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: daysAgo.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " day" + ((daysAgo != 1) ? "s" : "") + " ago",
            )
          ],
        ),
      ),
    );
  }
}
