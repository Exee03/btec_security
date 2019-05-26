import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Status {
  final String status;
  final String time;
  final String detail;
  const Status({
    @required this.status,
    @required this.time,
    @required this.detail
  });

  Status.fromMap(DocumentSnapshot data)
      : this(
          status: data['status'],
          time: data['time'],
          detail: data['detail'],
        );
}