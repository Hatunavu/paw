import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/profile/bloc/profile_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  UserRepository _userRepository;
  ProfileCubit(this._userRepository) : super(ProfileStateInitial());
  void getProfile(String uid) {
    _userRepository.getProfile(uid).then((value) => value.listen(
        (snapshot) => emit(ProfileStateSuccess(Userr.fromDoc(snapshot)))));
  }

  void readNoti() {
    _userRepository.readNoti();
  }
}
