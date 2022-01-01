import 'dart:async';
import 'package:demo_git/features/authentication/bloc/login/login_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;
  LoginCubit(this._userRepository) : super(LoginStateInitial());

  String verID = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> sentOtpEvent(String phoneNumber) async {
    emit(LoginStateLoading());

    await sentOtp(phoneNumber);
  }

  void otpSent() => emit(LoginStateOtpSent());

  void complete(UserCredential user) {
    emit(LoginStateComplete(user));
  }

  void exception(String message) {
    emit(LoginStateException(message));
  }

  void back() {
    emit(LoginStateBack());
  }

  Future<void> verifyOtp(String otp) async {
    emit(LoginStateOtpLoading());
    try {
      final UserCredential credential =
          await _userRepository.verifyAndLogin(verID, otp);
      if (credential.user != null) {
        if (credential.additionalUserInfo.isNewUser) {}
        emit(LoginStateComplete(credential));
      } else {
        emit(LoginStateOtpException('Invalid otp'));
      }
    } catch (e) {
      emit(LoginStateOtpException('Invalid otp'));
    }
  }

  Future<void> sentOtp(String phoneNumber) async {
    final phoneVerificationCompleted = (AuthCredential authCredential) async {
      // _userRepository.getUser();
      // _userRepository.getUser().catchError((onError) {}).then((user) {
      //   complete(user);
      // });
    };
    final phoneVeriaficationFailed = (FirebaseAuthException authException) {
      exception('Invalid phone number');
      print(authException.code);
    };
    final phoneCodeSent = (String verID, [int forceResent]) {
      this.verID = verID;
      otpSent();
    };
    final phoneCodeAutoRetrievalTimeOut = (String verid) {
      verID = verid;
    };
    await _userRepository.sentOtp(
        phoneNumber: phoneNumber,
        timeOut: const Duration(seconds: 1),
        phoneVerificationFailed: phoneVeriaficationFailed,
        phoneVerificationCompleted: null,
        phoneCodeSent: phoneCodeSent,
        autoRetrievalTimeout: phoneCodeAutoRetrievalTimeOut);
  }
}
