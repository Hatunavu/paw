import 'package:equatable/equatable.dart';

class PostUserState extends Equatable {
  var postUser;
  PostUserState(this.postUser);
  @override
  List<Object> get props => [postUser];
}

// class PostUserStateInitial extends PostUserState {}

// class PostUserStateSuccess extends PostUserState {
//   var postUser;
//   PostUserStateSuccess(this.postUser);
//   @override
//   List<Object> get props => [postUser];
// }
