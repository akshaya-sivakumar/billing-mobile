class BranchDetail {
  BranchDetail({
    required this.ID,
    required this.CreatedAt,
    required this.UpdatedAt,
     this.DeletedAt,
    required this.branchName,
  });
  late final int ID;
  late final String CreatedAt;
  late final String UpdatedAt;
  late final Null DeletedAt;
  late final String branchName;
  
  BranchDetail.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    CreatedAt = json['CreatedAt'];
    UpdatedAt = json['UpdatedAt'];
    DeletedAt = null;
    branchName = json['branchName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['CreatedAt'] = CreatedAt;
    _data['UpdatedAt'] = UpdatedAt;
    _data['DeletedAt'] = DeletedAt;
    _data['branchName'] = branchName;
    return _data;
  }
}