import 'package:demo_git/features/profile/bloc/following_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingCubit extends Cubit<FollowingState> {
  UserRepository _userRepository;
  FollowingCubit(this._userRepository) : super(FollowingStateIntitial());

  void getFollowing({@required String uid}) {
    _userRepository.getFollowing(uid: uid).then((value) =>
        value.listen((snapshot) => emit(FollowingStateSuccess(snapshot.docs))));
  }
}
