import 'package:btec_security/models/status.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class StatusState extends Equatable {
  const StatusState();
  @override
  List<Object> get props => [];
}
  
class InitialStatusState extends StatusState {}

class StatusLoading extends StatusState {
  @override
  String toString() => 'StatusLoading';
}

class StatusLoaded extends StatusState {
  final List<Status> status;

  StatusLoaded({@required this.status}) : assert (status != null);

  @override
  String toString() => 'StatusLoaded { todos: $status }';
} 

class StatusNotLoaded extends StatusState {
  @override
  String toString() => 'StatusNotLoaded';
}

class StatusEmpty extends StatusState {
  @override
  String toString() => 'StatusEmpty';
}

class StatusError extends StatusState {
  @override
  String toString() => 'StatusError';
}