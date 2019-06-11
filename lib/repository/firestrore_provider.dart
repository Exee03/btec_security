import 'dart:async';
import 'package:btec_security/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final Firestore _firestore = Firestore.instance;

  Future<List<Status>> fetchStatusByDay(String uid) async {
    print(uid);
    DateTime date = DateTime.now();
    String dateNow = '${date.day}-${date.month}-${date.year}';
    List<Status> status = [];

    QuerySnapshot doc = await _firestore
        .collection('history')
        .document(uid)
        .collection(dateNow)
        .getDocuments();
    List<DocumentSnapshot> data = doc.documents;
    for (int i = 0; i < data.length; i++) {
      status.add(Status(
          title: data[i].data['title'],
          time: data[i].data['time'],
          detail: data[i].data['detail']));
    }

    print("length after = ${status.length}");
    status.forEach((f) => print(f));
    return status;
  }
}
