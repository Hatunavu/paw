import 'package:equatable/equatable.dart';

class FillHealthState extends Equatable {
  @override
  List<Object> get props => [];
}

class FillHealthStateInitial extends FillHealthState {}

class FillHealthStateLoading extends FillHealthState {}

class FillHealthStateFailure extends FillHealthState {}

class FillHealthStateSuccess extends FillHealthState {}
