import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class History {
  final String title;
  final String time;
  final String detail;
  const History({
    @required this.title,
    @required this.time,
    @required this.detail
  });

  History.fromMap(DocumentSnapshot data)
      : this(
          title: data['title'],
          time: data['time'],
          detail: data['detail'],
        );
}