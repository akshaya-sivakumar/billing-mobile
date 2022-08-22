part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupRequestEvent extends SignupEvent {
  final CreateuserRequest signupRequest;

  SignupRequestEvent(this.signupRequest);
}

class FetchUserEvent extends SignupEvent {}

class DeleteUserEvent extends SignupEvent {
  final int id;

  DeleteUserEvent(this.id);
}
