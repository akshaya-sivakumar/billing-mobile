class UserDetail {
  UserDetail({
    required this.ID,
    required this.CreatedAt,
    required this.UpdatedAt,
     this.DeletedAt,
    required this.username,
    required this.password,
    required this.token,
    required this.role,
    required this.branch,
  });
  late final int ID;
  late final String CreatedAt;
  late final String UpdatedAt;
  late final Null DeletedAt;
  late final String username;
  late final String password;
  late final String token;
  late final String role;
  late final int branch;
  
  UserDetail.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    CreatedAt = json['CreatedAt'];
    UpdatedAt = json['UpdatedAt'];
    DeletedAt = null;
    username = json['username'];
    password = json['password'];
    token = json['token'];
    role = json['role'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['CreatedAt'] = CreatedAt;
    _data['UpdatedAt'] = UpdatedAt;
    _data['DeletedAt'] = DeletedAt;
    _data['username'] = username;
    _data['password'] = password;
    _data['token'] = token;
    _data['role'] = role;
    _data['branch'] = branch;
    return _data;
  }
}