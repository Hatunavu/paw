import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  @override
  List<Object> get props => [];
}

class LikeStateInitial extends LikeState {}

class LikeStateSuccess extends LikeState {
  var likes;
  bool isLiked;
  LikeStateSuccess(this.likes, this.isLiked);
  @override
  List<Object> get props => [likes, isLiked];
}
