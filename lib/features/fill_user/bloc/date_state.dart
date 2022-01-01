import 'package:equatable/equatable.dart';

class DateState extends Equatable {
  DateTime dateTime;
  DateState(this.dateTime);
  @override
  List<Object> get props => [dateTime];
}
