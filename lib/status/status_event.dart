import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class StatusEvent extends Equatable {
  StatusEvent([List props = const []]) : super(props);
}

class ListStarted extends StatusEvent {
  final FirebaseUser user;

  ListStarted({@required this.user})
      : assert(user != null);

  @override
  String toString() => 'ListStarted';
}

class LoadStatus extends StatusEvent {
  @override
  String toString() => 'LoadStatus';
}