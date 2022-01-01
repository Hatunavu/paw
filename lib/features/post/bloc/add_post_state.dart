import 'package:equatable/equatable.dart';

class AddPostState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddPostStateInitial extends AddPostState {}

class AddPostStateSuccess extends AddPostState {}

class AddPostStateFailure extends AddPostState {}

class AddPostStateLoading extends AddPostState {}
