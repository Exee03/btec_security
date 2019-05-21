import 'package:btec_security/data.dart';
import 'package:btec_security/ui/widgets/chart/attendance_chart.dart';
import 'package:btec_security/ui/widgets/table/attendance_table.dart';
import 'package:btec_security/utils/custom_colors.dart';
import 'package:btec_security/utils/custom_fonts.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/rendering.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({this.menu});
  final Menu menu;
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime timeNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.menu.colors,
        centerTitle: true,
        title: Text(
          widget.menu.title,
          style: CustomFonts.appBar,
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: widget.menu.colors,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          formatDate(timeNow, ['DD']),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${timeNow.day} / ${timeNow.month} / ${timeNow.year}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Total Employee : ',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: new BoxDecoration(
                      color: Colors.white12,
                      shape: BoxShape.circle,
                    ),
                    child: AttendanceChart(),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: CustomColors.front,
              child: Container(
                child: AttendanceTable(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
