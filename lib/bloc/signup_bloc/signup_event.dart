part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}
class SignupRequestEvent extends SignupEvent {
  final LoginRequest signupRequest;

  SignupRequestEvent(this.signupRequest);
}