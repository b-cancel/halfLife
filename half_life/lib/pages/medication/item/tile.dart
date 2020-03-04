import 'package:flutter/material.dart';

//plugins
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

//internal
import 'package:half_life/pages/medication/item/options.dart';
import 'package:half_life/pages/medication/item/pill.dart';
import 'package:half_life/pages/medication/item/arrow.dart';
import 'package:half_life/shared/tileDivider.dart';
import 'package:half_life/shared/timeOfDay.dart';

//widget
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
    @required this.activeDose,
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
  final double activeDose;
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
  final ValueNotifier<bool> isOpening = new ValueNotifier<bool>(false);
  final Duration animationDuration = Duration(milliseconds: 300);

  maybeScrollHere() {
    widget.autoScrollController.scrollToIndex(
      widget.id,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  scrollToIfOpen() {
    if (isOpening.value) {
      //we are opening it
      Future.delayed(animationDuration, () {
        //we let it open
        if (isOpening.value &&
            widget.autoScrollController.isAutoScrolling == false) {
          maybeScrollHere();
        }
      });
    }
  }

  maybeClose() {
    //we toggle it so we stay open
    if (weWillOpen) {
      weWillOpen = false;
      isOpening.value = true;
    } else {
      //someone else toggle it so we close
      isOpening.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    isOpening.addListener(scrollToIfOpen);
    widget.othersCloseOnToggle.addListener(maybeClose);
  }

  @override
  void dispose() {
    widget.othersCloseOnToggle.removeListener(maybeClose);
    isOpening.removeListener(scrollToIfOpen);
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
                if (isOpening.value == false) {
                  weWillOpen = true;
                  widget.othersCloseOnToggle.value =
                      !widget.othersCloseOnToggle.value;
                  //NOTE: this will cause isOpening to be updated to true
                  //only for us becuase of weWillOpen being set to true
                } else {
                  //closing ourselves means we are the only open ones
                  isOpening.value = false;
                }
              },
              leading: ToTimeOfDay(
                timeStamp: widget.timeTaken,
              ),
              title: Row(
                children: [
                  Text(
                    "Taken on ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  WeekDayYear(
                    dateTime: widget.timeTaken,
                  ),
                ],
              ),
              subtitle: PillSubtitle(
                activeDoseAfter: widget.activeDose,
                dose: widget.dose,
              ),
              trailing: RotatingIcon(
                color: ThemeData.dark().scaffoldBackgroundColor, 
                duration: animationDuration,
                isOpen: isOpening,
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
        animation: isOpening,
        child: header,
        builder: (context, child) {
          //we only need to make the curve
          //if we arent the last tile
          bool curve = widget.isLast;
          if (curve == false) {
            curve = isOpening.value;
          }

          //build
          return Column(
            children: <Widget>[
              Stack(
                fit: StackFit.passthrough,
                overflow: Overflow.visible,
                children: [
                  Corners(
                    animationDuration: animationDuration,
                    isOpen: isOpening,
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
              AnimatedContainer(
                duration: animationDuration,
                height: isOpening.value ? 72 : 0,
                child: Center(
                  child: Options(
                    dose: widget.dose,
                    initialDate: widget.timeTaken,
                    isLast: widget.isLast,
                  ),
                ),
              ),
            ],
          );
        },
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