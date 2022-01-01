import 'package:equatable/equatable.dart';

class FollowState extends Equatable {
  @override
  List<Object> get props => [];
}

class FollowStateInitial extends FollowState {}

class FollowStateLoading extends FollowState {}

class FollowStateSuccess extends FollowState {
  var followers;
  bool isFollowing;
  FollowStateSuccess(this.followers, this.isFollowing);
  @override
  List<Object> get props => [followers, isFollowing];
}
