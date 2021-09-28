import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatelessWidget {
  LineChart({Key? key, this.lineChartDataList}) : super(key: key);

  final List<LineChartData>? lineChartDataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        rangePadding: ChartRangePadding.round, interval: 1),
                    series: <ChartSeries>[
          // Renders line chart
          LineSeries<LineChartData, String>(
            // width: 10.0,
            isVisible: true,
            dataSource: lineChartDataList!,
            pointColorMapper: (LineChartData lineChartData, _) => Colors.blue,
            xValueMapper: (LineChartData lineChartData, _) =>
                lineChartData.area,
            yValueMapper: (LineChartData lineChartData, _) =>
                lineChartData.noOfCases,
          )
        ]))));
  }
}

class LineChartData {
  LineChartData(this.area, this.noOfCases);

  final String area;
  final double noOfCases;
}
