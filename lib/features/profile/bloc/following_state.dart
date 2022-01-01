import 'package:equatable/equatable.dart';

class FollowingState extends Equatable {
  @override
  List<Object> get props => [];
}

class FollowingStateIntitial extends FollowingState {}

class FollowingStateSuccess extends FollowingState {
  var following;
  FollowingStateSuccess(this.following);
  @override
  List<Object> get props => [following];
}
