import 'package:equatable/equatable.dart';

class LocationState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationStateInitial extends LocationState {}

class LocationStateLoading extends LocationState {}

class LocationStateSuccess extends LocationState {
  String location;
  LocationStateSuccess(this.location);
  @override
  List<Object> get props => [location];
}
