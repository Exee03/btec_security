import 'package:cloud_firestore/cloud_firestore.dart';

class Todos {
  final int id;
  final String title;
  final String detail;
  final String date;
  final String time;
  final bool complete;

  const Todos(
      {this.id,
      this.title,
      this.detail,
      this.date,
      this.time,
      this.complete});

  Todos.fromMap(DocumentSnapshot data, int index)
      : this(
          id: index,
          title: data['title'],
          detail: data['detail'],
          date: data['date'],
          time: data['time'],
          complete: data['complete'],
        );
}
