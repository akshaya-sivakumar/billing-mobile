class LoginResponse {
  LoginResponse({
    required this.username,
    required this.token,
  });
  late final String username;
  late final String token;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['token'] = token;
    return _data;
  }
}
