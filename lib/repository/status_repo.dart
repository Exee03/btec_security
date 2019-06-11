import 'package:btec_security/models/model.dart';
import 'package:btec_security/repository/firestrore_provider.dart';

class StatusRepository {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future<List<Status>> fetchStatusByDay(String uid) =>
      _firestoreProvider.fetchStatusByDay(uid);

}

