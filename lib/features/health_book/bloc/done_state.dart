import 'package:equatable/equatable.dart';

class DoneState extends Equatable {
  final bool done;
  DoneState(this.done);
  @override
  List<Object> get props => [done];
}
