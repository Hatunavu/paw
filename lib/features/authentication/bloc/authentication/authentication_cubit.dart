import 'package:demo_git/features/authentication/bloc/authentication/authentication_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationCubit(this._userRepository)
      : super(AuthenticationStateInitial());
  Future<void> started() async {
    try {
      final bool hasToken = await _userRepository.getUser() != null;
      if (hasToken) {
        emit(AuthenticationStateAuthenticated());
      } else {
        emit(AuthenticationStateUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationStateFailure());
    }
  }

  Future<void> loggedIn() async {
    try {
      emit(AuthenticationStateAuthenticated());
    } catch (e) {
      emit(AuthenticationStateFailure());
    }
  }

  Future<void> loggedOut() async {
    await _userRepository.signOut();
    emit(AuthenticationStateUnauthenticated());
  }
}
