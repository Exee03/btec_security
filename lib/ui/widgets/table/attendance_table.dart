import 'package:btec_security/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var attendance = <AttendanceModel>[
  AttendanceModel(time: DateTime.now().toString(), name: 'aaa')
];

class AttendanceTable extends StatefulWidget {
  AttendanceTable({this.data, this.colors, this.index});
  final DocumentSnapshot data;
  final Color colors;
  final int index;
  @override
  _AttendanceTableState createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  DateTime date = DateTime.now();
  String dateNow;

  Widget bodyData(AttendanceModel attendances) => Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                child: Text(
              attendances.time,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Text(
                attendances.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
      );

  @override
  void initState() {
    super.initState();
    attendance.clear();
    dateNow = '${date.day}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return bodyData(AttendanceModel.fromMap(widget.data, widget.index));
  }
}
