import 'package:demo_git/data/model/location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AroundState extends Equatable {
  @override
  List<Object> get props => [];
}

class AroundStateInitial extends AroundState {}

class AroundStateFailure extends AroundState {}

class AroundStateSuccess extends AroundState {
  List<Locationn> locations;
  Locationn currentLocation;
  AroundStateSuccess(
      {@required this.locations, @required this.currentLocation});
  @override
  List<Object> get props => [locations, currentLocation];
}
