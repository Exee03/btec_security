import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Status {
  final String title;
  final String time;
  final String detail;
  const Status({
    @required this.title,
    @required this.time,
    @required this.detail
  });

  Status.fromMap(DocumentSnapshot data)
      : this(
          title: data['title'],
          time: data['time'],
          detail: data['detail'],
        );
}