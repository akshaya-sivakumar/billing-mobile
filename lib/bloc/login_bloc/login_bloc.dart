import 'dart:convert';

import 'package:billing/repository/login_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/login_request.dart';
import '../../models/login_response.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequestEvent>((event, emit) async {
      LoginResponse response;
      emit(LoginLoad());

      try {
        response = await LoginRepository().login(event.loginRequest);
        emit(LoginDone(response));
      } catch (e) {
        print(e);
        emit(LoginError(e.toString()));
      }
    });
  }
}
