class LoginRequest {
  LoginRequest({
    required this.Username,
    required this.Password,
  });
  late final String Username;
  late final String Password;
  
  LoginRequest.fromJson(Map<String, dynamic> json){
    Username = json['Username'];
    Password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Username'] = Username;
    _data['Password'] = Password;
    return _data;
  }
}