import 'package:btec_security/ui/widgets/chart/attendance_chart.dart';
import 'package:btec_security/ui/widgets/table/attendance_table.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime timeNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: Theme.of(context).accentColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(formatDate(timeNow, ['DD'])),
                        Text(
                            '${timeNow.day} / ${timeNow.month} / ${timeNow.year}'),
                        Text('Total Employee : ')
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  child: AttendanceChart(),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: CustomColors.front,
              child: AttendanceTable(),
            ),
          )
        ],
      ),
    );
  }
}
