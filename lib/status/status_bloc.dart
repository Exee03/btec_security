import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:btec_security/models/model.dart';
import 'package:btec_security/repository/status_repo.dart';
import './bloc.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository statusRepository;

  StatusBloc({this.statusRepository}) : assert(statusRepository != null);

  @override
  StatusState get initialState => InitialStatusState();

  @override
  Stream<StatusState> mapEventToState(
       StatusEvent event) async* {
    print("mapEventToState");
    yield StatusLoading();
    try {
      List<Status> listStatus;
      if (event is ListStarted) {
        listStatus = await statusRepository.fetchStatusByDay(event.user.uid);
        print(listStatus);
      }
      if (listStatus.length == 0) {
        yield StatusEmpty();
      } else {
        yield StatusLoaded(status: listStatus);
      }
    } catch (_) {
      yield StatusError();
    }
  }
}