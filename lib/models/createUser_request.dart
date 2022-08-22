class CreateuserRequest {
  CreateuserRequest({
    required this.Username,
    required this.Password,
    required this.Role,
    required this.Branch,
  });
  late final String Username;
  late final String Password;
  late final String Role;
  late final int Branch;

  CreateuserRequest.fromJson(Map<String, dynamic> json) {
    Username = json['Username'];
    Password = json['Password'];
    Role = json['Role'];
    Branch = json['Branch'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Username'] = Username;
    _data['Password'] = Password;
    _data['Role'] = Role;
    _data['Branch'] = Branch;
    return _data;
  }
}
