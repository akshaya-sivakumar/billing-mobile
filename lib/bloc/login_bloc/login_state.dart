part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoad extends LoginState {}

class LoginDone extends LoginState {
  final LoginResponse loginResponse;

  LoginDone(this.loginResponse);
}

class LoginError extends LoginState {}
