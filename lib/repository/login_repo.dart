import 'dart:convert';

import 'package:billing/constants/app_strings.dart';
import 'package:billing/models/login_request.dart';
import 'package:billing/models/login_response.dart';
import 'package:billing/resources/api_base_helper.dart';

class LoginRepository {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    var response =
        await ApiBaseHelper().postMethod("/signin/", json.encode(loginRequest));

    LoginResponse loginResponse =
        LoginResponse.fromJson(json.decode(response.body));

    return loginResponse;
  }
}
