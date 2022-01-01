import 'package:demo_git/features/profile/bloc/post_user_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostUserCubit extends Cubit<PostUserState> {
  UserRepository _userRepository;
  PostUserCubit(this._userRepository) : super(PostUserState(null));

  void getPostUser(String uid) {
    _userRepository.getPostUser(uid).then((value) =>
        value.listen((snapshot) => emit(PostUserState(snapshot.docs))));
  }
}
