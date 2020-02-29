//dart
import 'dart:math' as math;

/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:half_life/struct/doses.dart';

/*
double activeDose = 24; //calcActiveDose();
    double maxDose = maxActiveDose - activeDose;
*/

//1 for pixelsBeforeNewPoint
//is perfect curve but we may want to do less for performance
class HeaderChart extends StatefulWidget {
  HeaderChart({
    @required this.screenWidth,
    this.pixelsBeforeNewPoint: 1,
    @required this.halfLife,
    @required this.doses,
    @required this.lastDateTime,
  });

  final double screenWidth;
  final double pixelsBeforeNewPoint;
  final Duration halfLife;
  final List<Dose> doses;
  final ValueNotifier<DateTime> lastDateTime;

  @override
  _HeaderChartState createState() => _HeaderChartState();
}

class _HeaderChartState extends State<HeaderChart> {
  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if(selectedDatum.isNotEmpty){
      print("DT: " + selectedDatum.first.datum.timeStamp.toString());
    }
    else print("EMPTY");

    /*
    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }

    // Request a build.
    setState(() {
      //_time = time;
      //_measures = measures;
    });
    */
  }

  List<charts.Series> seriesList;
  DateTime onHeaderLoad;

  updateSeries(){
    print("updated***************");
    seriesList = fromDoses(dosePoints());
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //dose point init
    seriesList = fromDoses(dosePoints());

    //listen to date time changes
    widget.lastDateTime.addListener(updateSeries);
  }

  @override
  void dispose() {
    widget.lastDateTime.removeListener(updateSeries);

    //super dipose
    super.dispose();
  }

  List<Dose> dosePoints(){
    int maxPoints = widget.screenWidth ~/ widget.pixelsBeforeNewPoint;
    List<Dose> dosePoints = new List<Dose>(maxPoints);

    //sort our doses to our first dose is our first dose
    widget.doses.sort((a, b) => b.compareTo(a));

    //grab basic range information
    DateTime dayFirstTaken = widget.doses[0].timeStamp;
    onHeaderLoad = DateTime.now();
    Duration timeSinceFirstTaken = onHeaderLoad.difference(dayFirstTaken);
    
    //create/update all of our dosePoints
    for(int pointID = 0; pointID < maxPoints; pointID++){
      double totalDoseForThisPoint = 0;

      //start at 0(first dose DT), ends at 1(right now)
      double distancePercentFromFirstToNow = (pointID / maxPoints);

      //each point indicates a last date time
      Duration timeSinceFirstForThisPoint = Duration(
        microseconds: (timeSinceFirstTaken.inMicroseconds * distancePercentFromFirstToNow).round(),
      );
      DateTime lastDateTimeForThisPoint = dayFirstTaken.add(timeSinceFirstForThisPoint);

      //iterate through all the doses and see which ones we should include and include them
      for(int i = 0; i < widget.doses.length; i++){
        bool doseBefore = widget.doses[i].timeStamp.isBefore(lastDateTimeForThisPoint);
        bool doseAt = widget.doses[i].timeStamp.difference(lastDateTimeForThisPoint) == Duration.zero;
        if(doseAt || doseBefore){
          //TODO: could add segment data here

          double dose = widget.doses[i].value;
          DateTime timeTaken = widget.doses[i].timeStamp;
          Duration timeSinceTaken = lastDateTimeForThisPoint.difference(timeTaken);

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
        totalDoseForThisPoint,
        lastDateTimeForThisPoint,
      );
    }

    //so the graph can be generated from them
    return dosePoints;
  }

  @override
  Widget build(BuildContext context) {
    double pointSize = 8;
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      //reads the informatio of the point we are currently viewing
      selectionModels: [
        new charts.SelectionModelConfig(
          //change in selection
          changedListener: onSelectionChanged,
          //anytime update selection
          //updatedListener: onSelectionChanged,
        )
      ],
      behaviors: [
        //show lines on selection X and Y axis
        charts.LinePointHighlighter(
          //what to show
          showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.all,
          showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.all,
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
        )

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
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Dose, DateTime>> fromDoses(List<Dose> dosePoints) {
    return [
      new charts.Series<Dose, DateTime>(
        id: 'Doses',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Dose dose, _) => dose.timeStamp,
        measureFn: (Dose dose, _) => dose.value,
        data: dosePoints,
      )
    ];
  }
}