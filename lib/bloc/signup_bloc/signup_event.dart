part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupRequestEvent extends SignupEvent {
  final CreateuserRequest signupRequest;

  SignupRequestEvent(this.signupRequest);
}

class FetchUserEvent extends SignupEvent {}
