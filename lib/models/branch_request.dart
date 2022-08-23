class BranchRequest {
  BranchRequest({
    required this.Branchname,
  });
  late final String Branchname;
  
  BranchRequest.fromJson(Map<String, dynamic> json){
    Branchname = json['Branchname'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Branchname'] = Branchname;
    return _data;
  }
}