class LoginResponse {
  LoginResponse({
    required this.message,
    required this.token,
  });
  late final String message;
  late final String token;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['token'] = token;
    return _data;
  }
}
