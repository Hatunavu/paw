import 'package:demo_git/data/local/app_preference.dart';
import 'package:demo_git/features/splash/bloc/first_login_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstLoginCubit extends Cubit<FirstLoginState> {
  UserRepository _userRepository;
  FirstLoginCubit(this._userRepository) : super(FirstLoginStateInitial());
  Future<void> started() async {
    final bool isFirstLogin = await AppPreferences.isFirstLogin();
    if (isFirstLogin == true) {
      emit(FirstLoginStateTrue());
    } else {
      emit(FirstLoginStateFalse());
    }
  }

  Future<void> isFirstLogin() async {
    await _userRepository.setFirstLogin(true);
    emit(FirstLoginStateTrue());
  }

  Future<void> isSecondLogin() async {
    await _userRepository.setFirstLogin(false);
    emit(FirstLoginStateFalse());
  }
}
