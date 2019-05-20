import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class AttendanceModel {
  final DateTime time;
  final String studentId;
  final String studentName;
  const AttendanceModel({this.time, this.studentId, this.studentName});
}

var attendance = <AttendanceModel>[
  AttendanceModel(time: DateTime.now(), studentId: '0', studentName: 'aaa')
];

class AttendanceTable extends StatefulWidget {
  @override
  _AttendanceTableState createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  Future loadData() async {
    attendance.add(AttendanceModel(
        time: DateTime.now(), studentId: '2', studentName: 'asdasdsadasd'));
    attendance.add(AttendanceModel(
        time: DateTime.now(), studentId: '3', studentName: 'cvbvcbcvbvbcvb'));
  }

  Widget bodyData() => DataTable(
        columns: <DataColumn>[
          DataColumn(
              label: Row(children: <Widget>[
            Container(
                width: 60,
                child: Text(
                  'Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
            Container(
                width: 90,
                child: Text(
                  'StudentID',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
            Container(
                width: 120,
                child: Text(
                  'Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ))
          ])),
        ],
        rows: attendance
            .map((data) => DataRow(
                  cells: [
                    DataCell(Row(
                      children: <Widget>[
                        Container(
                            width: 60,
                            child: Text(
                              formatDate(data.time, [h, ':', nn, ' ', am]),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                        Container(
                            width: 90,
                            child: Text(
                              data.studentId,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )),
                        Container(
                            width: 150,
                            child: Text(
                              data.studentName,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )),
                  ],
                ))
            .toList(),
      );

  @override
  void initState() {
    super.initState();
    attendance.clear();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (attendance.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'No data in this Class',
        )),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: bodyData(),
    );
  }
}
