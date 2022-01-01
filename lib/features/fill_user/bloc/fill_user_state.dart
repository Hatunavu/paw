import 'package:equatable/equatable.dart';

class FillUserState extends Equatable {
  @override
  List<Object> get props => [];
}

class FillUserStateInitial extends FillUserState {}

class FillUserStateSuccess extends FillUserState {}

class FillUserStateFailure extends FillUserState {}

class FillUserStateLoading extends FillUserState {}
