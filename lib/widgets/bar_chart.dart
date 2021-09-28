import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatelessWidget {
  final List<ChartModel>? chartModelList;

  BarChart({this.chartModelList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 5,
          majorTickLines: const MajorTickLines(size: 0)),
      series: <ChartSeries>[
        BarSeries<ChartModel, String>(
            dataSource: chartModelList!,
            xValueMapper: (ChartModel chartModel, _) =>
                chartModel.label as String,
            yValueMapper: (ChartModel chartModel, _) => chartModel.value,
            width: 0.6,
            // Width of the bars
            spacing: 0.3 // Spacing between the bars
            )
      ],
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    ))));
  }
}

class ChartModel {
  ChartModel(this.label, this.value);

  final String? label;
  final double? value;
}
