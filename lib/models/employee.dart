import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final int id;
  final String profileUrl;
  final String name;
  final String level;
  final int attendance;
  final int salary;
  final double rating;
  final List<dynamic> ratingDetail;

  const Employee({
    this.id,
    this.profileUrl,
    this.name,
    this.level,
    this.attendance,
    this.salary,
    this.rating,
    this.ratingDetail,
  });

  Employee.fromMap(DocumentSnapshot data, int index)
      : this(
          id: index,
          profileUrl: data['profileUrl'],
          name: data['name'],
          level: data['level'],
          attendance: data['attendance'],
          salary: data['salary'],
          rating: data['rating'].toDouble(),
          ratingDetail: data['ratingDetail'],
        );
}
