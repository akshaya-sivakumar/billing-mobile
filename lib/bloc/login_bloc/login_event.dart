part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginRequestEvent extends LoginEvent {
  final LoginRequest loginRequest;

  LoginRequestEvent(this.loginRequest);
}
