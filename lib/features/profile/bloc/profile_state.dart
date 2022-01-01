import 'package:demo_git/data/model/userr.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileStateInitial extends ProfileState {}

class ProfileStateSuccess extends ProfileState {
  Userr userr;
  ProfileStateSuccess(this.userr);
  @override
  List<Object> get props => [userr];
}
