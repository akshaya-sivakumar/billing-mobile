class LoginResponse {
  LoginResponse({
    required this.message,
    required this.token,
    required this.role,
  });
  late final String message;
  late final String token;
  late final String role;
  late final int branch;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    role = json['role'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['token'] = token;
    _data['role'] = role;
    _data['branch'] = branch;
    return _data;
  }
}
