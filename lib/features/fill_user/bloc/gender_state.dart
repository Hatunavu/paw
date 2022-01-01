import 'package:equatable/equatable.dart';

class GenderState extends Equatable {
  int gender;
  GenderState(this.gender);
  @override
  List<Object> get props => [gender];
}
