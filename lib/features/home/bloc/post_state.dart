import 'package:equatable/equatable.dart';

class PostState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostStateInitial extends PostState {}

class PostStateLoading extends PostState {}

class PostStateNextLoading extends PostState {}

class PostStateSuccess extends PostState {
  final List posts;
  final bool hasReachedEnd;
  final List docs;
  PostStateSuccess({this.posts, this.hasReachedEnd, this.docs});
  @override
  List<Object> get props => [posts, hasReachedEnd, docs];
  PostStateSuccess cloneWith({List posts, bool hasReachedEnd, List docs}) {
    return PostStateSuccess(
        posts: posts ?? this.posts,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        docs: docs ?? this.docs);
  }
}

class PostStateFailure extends PostState {}
