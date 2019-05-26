import 'dart:async';
import 'package:btec_security/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final Firestore _firestore = Firestore.instance;

  Future<List<Status>> fetchStatusByDay(String uid) async {
    // FirebaseUser user = await _userRepository.getUser();
    print('..............sadasdsdasdasd..............$uid');
    DateTime date = DateTime.now();
    String dateNow = '${date.day}-${date.month}-${date.year}';
    List<Status> status = [];
    print(dateNow);
    print("length before = ${status.length}");
    // Stream<QuerySnapshot> snapshot = _firestore
    //     .collection('status')
    //     .snapshots();

    // .listen((onData) => onData.documents.forEach((doc) {
    //       print(doc['detail']);
    //       status.add(doc['detail']);
    //     }));

    // var reference = _firestore
    //     .collection('status')
    //     .document(uid)
    //     .collection(dateNow)
    //     .getDocuments().then((QuerySnapshot snapshot) {
    //   Status.fromMap(snapshot.documents.)
    // });
    // reference.listen((onData) => {
    //       onData.documents.forEach((data) => {
    //             status.add(Status.fromMap(data)),
    //           })
    //     });

    QuerySnapshot doc = await _firestore
        .collection('status')
        .document(uid)
        .collection(dateNow)
        .getDocuments();
    List<DocumentSnapshot> data = doc.documents;
    print(doc.documents.length);
    for (int i = 0; i < data.length; i++) {
      print(data[i].data['status']);
      status.add(Status(
          status: data[i].data['status'],
          time: data[i].data['time'],
          detail: data[i].data['detail']));
    }

    print("length after = ${status.length}");
    status.forEach((f) => print(f));
    return status;
    // return reference.getDocuments();
  }

  // List<Status> listStatus() {
  //   // if (snapshot.hasData) {
  //   //   return ApiResult.fromJson(responseString).items;
  //   // } else {
  //   //   throw Exception('failed to load players');
  //   // }
  // }
}
