//dart
import 'dart:math' as math;

/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:half_life/shared/conditional.dart';
import 'package:half_life/shared/timeOfDay.dart';
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/dateTimeFormat.dart';
import 'package:half_life/utils/goldenRatio.dart';

/*
double activeDose = 24; //calcActiveDose();
    double maxDose = maxActiveDose - activeDose;
*/

//1 for pixelsBeforeNewPoint
//is perfect curve but we may want to do less for performance
class HeaderChart extends StatefulWidget {
  HeaderChart({
    @required this.screenWidth,
    this.pixelsBeforeNewPoint: 4,
    @required this.halfLife,
    @required this.doses,
    @required this.lastDateTime,
    @required this.theSelectedDateTime,
  });

  final double screenWidth;
  final double pixelsBeforeNewPoint;
  final Duration halfLife;
  final List<Dose> doses;
  final ValueNotifier<DateTime> lastDateTime;
  final ValueNotifier<DateTime> theSelectedDateTime;

  @override
  _HeaderChartState createState() => _HeaderChartState();
}

class _HeaderChartState extends State<HeaderChart> {
  List<charts.Series> seriesList;
  double lastActiveDosage;
  ValueNotifier<DateTime> selectedDateTime;
  ValueNotifier<double> selectedActiveDosage;

  updateSeries() {
    seriesList = fromDoses(getDosePoints());
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //the date time used to calculated active dosage
    selectedDateTime = new ValueNotifier<DateTime>(
      widget.lastDateTime.value,
    );
    selectedActiveDosage = new ValueNotifier<double>(0);

    //dose point init
    seriesList = fromDoses(getDosePoints());

    //listen to date time changes
    widget.lastDateTime.addListener(updateSeries);
  }

  @override
  void dispose() {
    widget.lastDateTime.removeListener(updateSeries);

    //super dipose
    super.dispose();
  }

  //we don't care about all the doses that all together
  //at the moment are contributing to less than 1 of our dosage
  double maxIrelevantDose = 1;
  int getFirstDoseWeCareAbout(
    DateTime firstTaken,
    DateTime lastDate,
    Duration timeSinceFirstTaken,
  ) {
    double activeDoseSoFar = 0;
    for (int doseID = 0; doseID < widget.doses.length; doseID++) {
      double dose = widget.doses[doseID].value;
      DateTime timeTaken = widget.doses[doseID].timeStamp;
      Duration timeSinceTaken = lastDate.difference(timeTaken);

      //allways use duration in microseconds
      double decayConstant = math.log(2) / widget.halfLife.inMicroseconds;
      double exponent = -decayConstant * timeSinceTaken.inMicroseconds;
      double dosageLeft = dose * math.pow(math.e, exponent);

      //add to active dose
      activeDoseSoFar += dosageLeft;

      //if our active dose is no longer irelevant with this point
      //we found the first dose we care about
      if (activeDoseSoFar > maxIrelevantDose) {
        return doseID;
      }
    }

    //aparently we have nearly nothing left in our system
    return -1; //we don't care about any dose
  }

  //keep track of dose DT we have used
  //so we can change the selection pointer styling
  //and so we have to do less work for every run of this function
  Set<DateTime> doseDateTimesInChart = new Set<DateTime>();
  List<Dose> getDosePoints() {
    doseDateTimesInChart.clear();

    //we have never taken a dose
    if (widget.doses.length == 0)
      return [];
    else {
      //sort so the first dose is the first dose
      widget.doses.sort((a, b) => b.compareTo(a));

      //grab basic range information
      DateTime firstTaken = widget.doses[0].timeStamp;
      DateTime lastDate = widget.lastDateTime.value;
      Duration timeSinceFirstTaken = lastDate.difference(firstTaken);

      //so we can more usefully set the domain
      int firstDoseWeCareToShow = getFirstDoseWeCareAbout(
        firstTaken,
        lastDate,
        timeSinceFirstTaken,
      );

      //there are no doses we care to show
      if (firstDoseWeCareToShow == -1) {
        return null;
      } else {
        DateTime dateTimeOfDoseWeCareAbout =
            widget.doses[firstDoseWeCareToShow].timeStamp;
        Duration timeSinceDoseWeCareAbout = lastDate.difference(
          dateTimeOfDoseWeCareAbout,
        );

        //create the points
        int maxPoints = widget.screenWidth ~/ widget.pixelsBeforeNewPoint;
        List<Dose> dosePoints = new List<Dose>(maxPoints);

        //create/update all of our dosePoints
        for (int pointID = 0; pointID < maxPoints; pointID++) {
          createPoint(
            dosePoints,
            pointID: pointID,
            //start at 0(first dose DT), ends at 1(right now)
            percentToEnd: (pointID / maxPoints),
            timeSinceDoseWeCareAbout: timeSinceDoseWeCareAbout,
            dateTimeOfDoseWeCareAbout: dateTimeOfDoseWeCareAbout,
          );
        }

        //save last dosage so we can return to it later
        lastActiveDosage = dosePoints.last.value;
        selectedActiveDosage.value = lastActiveDosage;

        //so the graph can be generated from them
        return dosePoints;
      }
    }
  }

  //we use percent to end if no ACTUAL dose start at this point
  //else we use that doses date time to calculate everything the percentToEnd would
  //TODO: do the above
  createPoint(
    List<Dose> dosePoints, {
    int pointID,
    double percentToEnd,
    Duration timeSinceDoseWeCareAbout,
    DateTime dateTimeOfDoseWeCareAbout,
  }) {
    double totalDoseForThisPoint = 0;

    //iterate through all the doses 
    //and check if its the first time we are working with one
    int doseUsedForFirstTime;
    for(int i = 0; i < widget.doses.length; i++){
      //TODO: finish this
    }

    //based on the baove determine the duration and date time to use everywhere below
    Duration timeSinceForThisPoint;
    if(doseUsedForFirstTime != null){
      Dose firstTimeUseDose = widget.doses[doseUsedForFirstTime];
      //TODO: make sure we are doing this right...
      timeSinceForThisPoint = widget.lastDateTime.value.difference(
        firstTimeUseDose.timeStamp,
      );
    }
    else{
      double ms = timeSinceDoseWeCareAbout.inMicroseconds * percentToEnd;
      timeSinceForThisPoint = Duration(
        microseconds: ms.round(),
      );
    }

    //will serve as upper limit
    DateTime lastDateTimeForThisPoint = dateTimeOfDoseWeCareAbout.add(
      timeSinceForThisPoint,
    );

    //iterate through all the doses and see which ones we should include and include them
    for (int i = 0; i < widget.doses.length; i++) {
      //easy access variables
      Dose thisDose = widget.doses[i];
      DateTime timeTaken = thisDose.timeStamp;
      Duration timeSinceTaken = lastDateTimeForThisPoint.difference(timeTaken);

      //other stuff
      bool doseBefore = timeTaken.isBefore(lastDateTimeForThisPoint);
      bool doseAt = (timeSinceTaken == Duration.zero);
      bool canUseDose = doseAt || doseBefore;

      //we can use this dose
      if (canUseDose) {
        double dose = thisDose.value;

        //allways use duration in microseconds
        double decayConstant = math.log(2) / widget.halfLife.inMicroseconds;
        double exponent = -decayConstant * timeSinceTaken.inMicroseconds;
        double dosageLeft = dose * math.pow(math.e, exponent);

        totalDoseForThisPoint += dosageLeft;
      }
      //ELSE: we don't count it
    }

    //add dose point
    dosePoints[pointID] = Dose(
      0, //id doesnt here
      totalDoseForThisPoint,
      lastDateTimeForThisPoint,
    );
  }

  @override
  Widget build(BuildContext context) {
    double pointSize = 8;
    return Stack(
      children: <Widget>[
        charts.TimeSeriesChart(
          seriesList,
          animate: true,
          //reads the informatio of the point we are currently viewing
          selectionModels: [
            new charts.SelectionModelConfig(
              //change in selection
              changedListener: (charts.SelectionModel model) {
                final selectedDatum = model.selectedDatum;
                if (selectedDatum.isNotEmpty) {
                  DateTime thisDateTime = selectedDatum.first.datum.timeStamp;
                  double activeDosage = selectedDatum.first.datum.value;
                  //set to the selected point
                  selectedDateTime.value = thisDateTime;
                  selectedActiveDosage.value = activeDosage;
                } else {
                  //set to last point
                  selectedDateTime.value = widget.lastDateTime.value;
                  selectedActiveDosage.value = lastActiveDosage;
                }
              },
              //anytime update selection
              //updatedListener: onSelectionChanged,
            )
          ],
          behaviors: [
            //show lines on selection X and Y axis
            charts.LinePointHighlighter(
              //what to show
              showHorizontalFollowLine:
                  charts.LinePointHighlighterFollowLineType.all,
              showVerticalFollowLine:
                  charts.LinePointHighlighterFollowLineType.all,
              //how to show it
              defaultRadiusPx: pointSize,
              radiusPaddingPx: 0,
              //make lines solid
              dashPattern: [],
              //we only need to see how it links up to the current axises
              //but its more obvious that something happened if its true
              drawFollowLinesAcrossChart: true,
              //render of points
              symbolRenderer: charts.CircleSymbolRenderer(
                isSolid: true,
              ),
            ),
            //allow tap and drag (instead of just tap)
            charts.SelectNearest(
              eventTrigger: charts.SelectionTrigger.tapAndDrag,
              //all the points that match this result are not needed in selection
              expandToDomain: false,
            ),
          ],
          /*
          // Optionally turn off the animation that animates values up from the
          // bottom of the domain axis. If animation is on, the bars will animate up
          // and then animate to the final viewport.
          animationDuration: Duration.zero,
          // Set the initial viewport by providing a new AxisSpec with the
          // desired viewport: a starting domain and the data size.
          domainAxis: new charts.OrdinalAxisSpec(
              viewport: new charts.OrdinalViewport('2018', 4)),
          behaviors: [
            // Add this behavior to show initial hint animation that will pan to the
            // final desired viewport.
            // The duration of the animation can be adjusted by pass in
            // [hintDuration]. By default this is 3000ms.
            new charts.InitialHintBehavior(maxHintTranslate: 4.0),
            // Optionally add a pan or pan and zoom behavior.
            // If pan/zoom is not added, the viewport specified remains the viewport
            new charts.PanAndZoomBehavior(),
          ],
          */
          // Optionally pass in a [DateTimeFactory] used by the chart. The factory
          // should create the same type of [DateTime] as the data provided. If none
          // specified, the default creates local date time.
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          /*
          behaviors: [
            // Add the sliding viewport behavior to have the viewport center on the
            // domain that is currently selected.
            new charts.SlidingViewport(),
            // A pan and zoom behavior helps demonstrate the sliding viewport
            // behavior by allowing the data visible in the viewport to be adjusted
            // dynamically.
            new charts.PanAndZoomBehavior(),
          ],
          // Set an initial viewport to demonstrate the sliding viewport behavior on
          // initial chart load.
          domainAxis: new charts.OrdinalAxisSpec(
              viewport: new charts.OrdinalViewport('2018', 4)),
          */
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: smallNumber,
                  child: Container(color: Colors.transparent),
                ),
                IgnorePointer(
                  child: ActiveDosageDisplay(
                    lastDateTime: widget.lastDateTime,
                    selectedDateTime: selectedDateTime,
                    selectedActiveDosage: selectedActiveDosage,
                  ),
                ),
                Flexible(
                  flex: largeNumber,
                  child: Container(color: Colors.transparent),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Dose, DateTime>> fromDoses(List<Dose> dosePoints) {
    return [
      new charts.Series<Dose, DateTime>(
        id: 'Doses',
        colorFn: (_, __) {
          Color dark = ThemeData.dark().scaffoldBackgroundColor;
          return charts.Color(r: dark.red, g: dark.green, b: dark.blue, a: 255);
        },
        domainFn: (Dose dose, _) => dose.timeStamp,
        measureFn: (Dose dose, _) => dose.value,
        data: dosePoints,
      )
    ];
  }
}

class ActiveDosageDisplay extends StatefulWidget {
  ActiveDosageDisplay({
    @required this.lastDateTime,
    @required this.selectedDateTime,
    @required this.selectedActiveDosage,
  });

  final ValueNotifier<DateTime> lastDateTime;
  final ValueNotifier<DateTime> selectedDateTime;
  final ValueNotifier<double> selectedActiveDosage;

  @override
  _ActiveDosageDisplayState createState() => _ActiveDosageDisplayState();
}

class _ActiveDosageDisplayState extends State<ActiveDosageDisplay> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.selectedDateTime.addListener(updateState);
  }

  @override
  void dispose() {
    widget.selectedDateTime.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //see if the user hasn't tried to select anything in particular
    DateTime lastDT = widget.lastDateTime.value;
    DateTime thisDT = widget.selectedDateTime.value;
    int secondsApart = thisDT.difference(lastDT).inSeconds;
    secondsApart *= (secondsApart < 0) ? -1 : 1;
    bool isLast = secondsApart <= 1;

    //build
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.selectedActiveDosage.value.round().toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
        ),
        Text(
          "Active",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        DefaultTextStyle(
          style: TextStyle(
            color: ThemeData.dark().scaffoldBackgroundColor,
          ),
          child: Conditional(
            condition: isLast,
            ifTrue: Text(
              "Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ifFalse: Column(
              children: <Widget>[
                Text(
                  DateTimeFormat.weekAndDay(widget.selectedDateTime.value),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateTimeFormat.monthAndYear(widget.selectedDateTime.value),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 4.0,
          ),
          child: ToTimeOfDay(
            timeStamp: widget.selectedDateTime.value,
          ),
        ),
      ],
    );
  }
}
