import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class LocationSettingState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationSettingStateInitial extends LocationSettingState {}

class LocationSettingStateLoading extends LocationSettingState {}

class LocationSettingStateSuccess extends LocationSettingState {
  final bool enableLocation;
  LocationSettingStateSuccess({@required this.enableLocation});
  @override
  List<Object> get props => [enableLocation];
}

class LocationSettingStateFailure extends LocationSettingState {}
