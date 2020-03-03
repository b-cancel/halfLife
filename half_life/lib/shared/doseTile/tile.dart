import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:half_life/shared/tileDivider.dart';
import 'package:half_life/utils/dateTimeFormat.dart';
import 'package:half_life/utils/durationFormat.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

class DoseTile extends StatefulWidget {
  const DoseTile({
    Key key,
    @required this.id,
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
    //for selected date time
    @required this.theSelectedDateTime,
    @required this.autoScrollController,
    @required this.othersCloseOnToggle,
  }) : super(key: key);

  final int id;
  final bool isFirst;
  final bool isLast;
  final bool isEven;
  final Color softHeaderColor;

  final double dose;
  final DateTime timeTaken;
  final Duration timeSinceTaken;

  final ValueNotifier<DateTime> theSelectedDateTime;
  final AutoScrollController autoScrollController;
  final ValueNotifier<bool> othersCloseOnToggle;

  @override
  _DoseTileState createState() => _DoseTileState();
}

class _DoseTileState extends State<DoseTile> {
  bool weWillOpen = false;
  final ValueNotifier<bool> isOpen = new ValueNotifier<bool>(false);
  final Duration animationDuration = Duration(milliseconds: 300);

  maybeScrollHere() {
    widget.autoScrollController.scrollToIndex(
      widget.id,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  scrollToIfOpen() {
    if (isOpen.value) { //we are opening it
      Future.delayed(animationDuration, () {
        //we let it open
        if (isOpen.value &&
            widget.autoScrollController.isAutoScrolling == false) {
          maybeScrollHere();
        }
      });
    }
  }

  maybeClose(){
    //we toggle it so we stay open
    if(weWillOpen){
      weWillOpen = false;
      isOpen.value = true;
    }
    else{ //someone else toggle it so we close
      isOpen.value = false;
    } 
  }

  @override
  void initState() {
    super.initState();
    isOpen.addListener(scrollToIfOpen);
    widget.othersCloseOnToggle.addListener(maybeClose);
  }

  @override
  void dispose() {
    widget.othersCloseOnToggle.removeListener(maybeClose);
    isOpen.removeListener(scrollToIfOpen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                //we are trying to open oursleves
                if(isOpen.value == false){
                  weWillOpen = true;
                  widget.othersCloseOnToggle.value = !widget.othersCloseOnToggle.value;
                } //closing ourselves means we are the only open ones
                else isOpen.value = false;
              },
              leading: ToTimeOfDay(
                timeStamp: widget.timeTaken,
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
                        widget.timeSinceTaken,
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
                      widget.timeTaken,
                    ),
              ),
              trailing: Text(
                widget.dose.round().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
              visible: widget.isLast == false,
              child: ListTileDivider(),
            ),
          ],
        ),
      ),
    );

    //used to scroll to the item on open
    return AutoScrollTag(
      controller: widget.autoScrollController,
      key: ValueKey(widget.id),
      index: widget.id,
      child: AnimatedBuilder(
        animation: isOpen,
        child: header,
        builder: (context, child) {
          //we only need to make the curve
          //if we arent the last tile
          bool curve = widget.isLast;
          if (curve == false) {
            curve = isOpen.value;
          }

          return Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.clip,
                children: [
                  OptionsTranslator(
                    isLast: widget.isLast,
                    animationDuration: animationDuration,
                    isOpen: isOpen,
                  ),
                  Corners(
                    animationDuration: animationDuration,
                    isOpen: isOpen,
                  ),
                  AnimatedContainer(
                    duration: animationDuration,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(curve ? 24 : 0),
                        bottomRight: Radius.circular(curve ? 24 : 0),
                      ),
                    ),
                    child: child,
                  ),
                ],
              ),
              OptionsSpacer(
                animationDuration: animationDuration,
                isOpen: isOpen,
              ),
            ],
          );
        },
      ),
    );
  }
}

class OptionsTranslator extends StatelessWidget {
  const OptionsTranslator({
    Key key,
    @required this.animationDuration,
    @required this.isOpen,
    @required this.isLast,
  }) : super(key: key);

  final Duration animationDuration;
  final ValueNotifier<bool> isOpen;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        duration: animationDuration,
        transform: Matrix4.translation(
          vect.Vector3(
            0,
            isOpen.value ? 72 : 0,
            0,
          ),
        ),
        child: Options(isLast: isLast),
      ),
    );
  }
}

class Options extends StatelessWidget {
  const Options({
    Key key,
    @required this.isLast,
  }) : super(key: key);

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
                    onPressed: () {},
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
                    onPressed: () {},
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
                    onPressed: () {
                      print("delete");
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

class OptionsSpacer extends StatelessWidget {
  const OptionsSpacer({
    Key key,
    @required this.animationDuration,
    @required this.isOpen,
  }) : super(key: key);

  final Duration animationDuration;
  final ValueNotifier<bool> isOpen;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedContainer(
        color: Colors.transparent,
        duration: animationDuration,
        height: isOpen.value ? 72 : 0,
      ),
    );
  }
}

class Corners extends StatelessWidget {
  const Corners({
    Key key,
    @required this.animationDuration,
    @required this.isOpen,
  }) : super(key: key);

  final Duration animationDuration;
  final ValueNotifier<bool> isOpen;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: animationDuration,
        transform: Matrix4.translation(
          vect.Vector3(
            0,
            isOpen.value ? 0 : -24,
            0,
          ),
        ),
        height: 36,
        color: ThemeData.dark().cardColor,
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
