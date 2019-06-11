import 'package:flutter/material.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class AttendanceChart extends StatefulWidget {
  AttendanceChart({this.attendance, this.total});
  final double attendance;
  final double total;
  @override
  _AttendanceChartState createState() => _AttendanceChartState();
}

class Employees {
  final String status;
  final double count;
  final Color color;

  Employees(this.status, this.count, this.color);
}

class _AttendanceChartState extends State<AttendanceChart> {
  double total;
  double attend;
  double remaining;

  var dataArray = [
    Employees('present', 0, Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    dataArray.clear();
    loadData();
  }

  Future loadData() async {
    attend = widget.attendance / widget.total * 100;
    print(attend);
    remaining = 100 - attend;
    print(remaining);
    setState(() {
      dataArray.add(Employees('Present', attend, Colors.green));
      dataArray.add(Employees('Absent', remaining, Colors.red));
    });
  }

  @override
  Widget build(BuildContext context) {
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
              attend.toDouble(),
              CustomColors.absent,
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              remaining.toDouble(),
              CustomColors.present,
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      percentageValues: true,
      holeLabel: '${attend.toString()}%',
      labelStyle: new TextStyle(
        color: Colors.white70,
        fontSize: 20.0,
      ),
      edgeStyle: SegmentEdgeStyle.round,
    );
  }
}
