import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {}

class LoginStateOtpSent extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateOtpLoading extends LoginState {}

class LoginStateBack extends LoginState {}

class LoginStateComplete extends LoginState {
  final UserCredential user;
  LoginStateComplete(this.user);
  UserCredential getUser() {
    return user;
  }

  @override
  List<Object> get props => [user];
}

class LoginStateException extends LoginState {
  final String message;
  LoginStateException(this.message);
  @override
  List<Object> get props => [message];
}

class LoginStateOtpException extends LoginState {
  final String message;
  LoginStateOtpException(this.message);
  @override
  List<Object> get props => [message];
}
