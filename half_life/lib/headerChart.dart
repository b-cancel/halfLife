/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:half_life/struct/doses.dart';

class HeaderChart extends StatelessWidget {
  HeaderChart({
    @required this.doses,
  });

  final List<Dose> doses;

  @override
  Widget build(BuildContext context) {
    List<charts.Series> seriesList = fromDoses();

    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Dose, DateTime>> fromDoses() {
    return [
      new charts.Series<Dose, DateTime>(
        id: 'Doses',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Dose dose, _) => dose.timeStamp,
        measureFn: (Dose dose, _) => dose.value,
        data: doses,
      )
    ];
  }
}