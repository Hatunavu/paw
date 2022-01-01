import 'package:equatable/equatable.dart';

class CommentState extends Equatable {
  @override
  List<Object> get props => [];
}

class CommentStateInitial extends CommentState {}

class CommentStateLoading extends CommentState {}

class CommentStateSuccess extends CommentState {
  var comments;
  CommentStateSuccess(this.comments);
  @override
  List<Object> get props => [comments];
}
