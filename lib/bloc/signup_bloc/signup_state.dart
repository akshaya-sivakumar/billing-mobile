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

class FetchUserDone extends SignupState {
  final List<UserDetail> userList;

  FetchUserDone(this.userList);
}

class FetchUserLoad extends SignupState {}

class FetchUserError extends SignupState {
  final String error;

  FetchUserError(this.error);
}

class UserDeleteLoad extends SignupState {}

class UserDeleted extends SignupState {}

class UserDeleteError extends SignupState {}

class UpdateUserLoad extends SignupState {}

class UpdateUserDone extends SignupState {}

class UpdateUserError extends SignupState {}
