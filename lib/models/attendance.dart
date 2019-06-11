import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final int id;
  final String time;
  final String name;
  const AttendanceModel({this.id, this.time, this.name});

  AttendanceModel.fromMap(DocumentSnapshot data, int index)
      : this(
          id: index,
          time: data['time'],
          name: data['name'],
        );
}
