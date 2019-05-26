// import 'dart:async';

// import 'package:btec_security/models/model.dart';
// import 'package:btec_security/repository/user_repo.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class StatusRepository {
//   final Firestore _firestore;
//   final UserRepository _userRepository;

//   StatusRepository({Firestore firestore, UserRepository userRepository})
//       : _firestore = firestore ?? Firestore.instance,
//         _userRepository = userRepository ?? userRepository.getUser();

//   Future<List<Status>> getData(String id) async {
//     // FirebaseUser user = await _userRepository.getUser();
//     print('..............sadasdsdasdasd..............$id');
//     DateTime date = DateTime.now();
//     String dateNow = '${date.day}-${date.month}-${date.year}';
//     List<Status> status = [];
//     Stream<QuerySnapshot> reference = _firestore
//         .collection('status')
//         .document(id)
//         .collection(dateNow)
//         .snapshots();
//     reference.listen((onData) => {
//           onData.documents.forEach((data) => {status.add(Status.fromMap(data))})
//         });
//     print("status repository : $id");
//     return status;
//     // return reference.getDocuments();
//   }
// }


import 'package:btec_security/models/model.dart';
import 'package:btec_security/repository/firestrore_provider.dart';

class StatusRepository {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<List<Status>> fetchStatusByDay(String uid) =>
      _firestoreProvider.fetchStatusByDay(uid);

}

