import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AttendanceChart extends StatefulWidget {
  @override
  _AttendanceChartState createState() => _AttendanceChartState();
}

class Student {
  final String status;
  final int count;
  final charts.Color color;

  Student(this.status, this.count, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _AttendanceChartState extends State<AttendanceChart> {
  int value;
  int remainingStudent;
  int totalStudent;

  var dataArray = [
    Student('present', 0, Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    dataArray.clear();
    loadData();
  }

  Future loadData() async {
    value = 60;
    remainingStudent = 100 - value;
    setState(() {
      dataArray.add(Student('Present', value, Colors.green));
      dataArray.add(Student('Absent', remainingStudent, Colors.red));
    });
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        domainFn: (Student days, _) => days.status,
        measureFn: (Student days, _) => days.count,
        colorFn: (Student days, _) => days.color,
        id: 'Days',
        data: dataArray,
        labelAccessorFn: (Student days, _) => '${days.count}',
      )
    ];

    var chart = charts.PieChart(
      series,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [charts.ArcLabelDecorator()],
        // arcWidth: 20,
      ),
      animate: true,
    );

    if (dataArray.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return chart;
  }
}
