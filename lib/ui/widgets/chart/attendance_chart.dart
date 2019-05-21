import 'package:flutter/material.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class AttendanceChart extends StatefulWidget {
  @override
  _AttendanceChartState createState() => _AttendanceChartState();
}

class Student {
  final String status;
  final int count;
  final Color color;

  Student(this.status, this.count, this.color);
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
    // var series = [
    //   charts.Series(
    //     domainFn: (Student days, _) => days.status,
    //     measureFn: (Student days, _) => days.count,
    //     colorFn: (Student days, _) => days.color,
    //     id: 'Days',
    //     data: dataArray,
    //     labelAccessorFn: (Student days, _) => '${days.count}',
    //   )
    // ];

    // var chart = charts.PieChart(
    //   series,
    //   defaultRenderer: charts.ArcRendererConfig(
    //     arcRendererDecorators: [charts.ArcLabelDecorator()],
    //     // arcWidth: 20,
    //   ),
    //   animate: true,
    // );

    // if (dataArray.length == 0) {
    //   return Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }

    final GlobalKey<AnimatedCircularChartState> _chartKey =
        new GlobalKey<AnimatedCircularChartState>();
    final _chartSize = const Size(100.0, 100.0);
    return new AnimatedCircularChart(
      key: _chartKey,
      size: _chartSize,
      holeRadius: 35,
      initialChartData: <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              value.toDouble(),
              CustomColors.absent,
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              remainingStudent.toDouble(),
              CustomColors.present,
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      percentageValues: true,
      holeLabel: '${value.toString()}%',
      labelStyle: new TextStyle(
        color: Colors.white70,
        fontSize: 20.0,
      ),
    );
  }
}
