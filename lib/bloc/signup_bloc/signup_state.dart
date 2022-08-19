part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoad extends SignupState {}

class SignupDone extends SignupState {
  final LoginResponse signupResponse;

  SignupDone(this.signupResponse);
}

class SignupError extends SignupState {
  final String error;

  SignupError(this.error);
}
