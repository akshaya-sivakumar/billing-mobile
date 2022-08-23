class SidedishDetail {
  SidedishDetail({
    required this.ID,
    required this.CreatedAt,
    required this.UpdatedAt,
     this.DeletedAt,
    required this.item,
    required this.quantity,
    required this.unit,
  });
  late final int ID;
  late final String CreatedAt;
  late final String UpdatedAt;
  late final Null DeletedAt;
  late final String item;
  late final String quantity;
  late final String unit;
  
  SidedishDetail.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    CreatedAt = json['CreatedAt'];
    UpdatedAt = json['UpdatedAt'];
    DeletedAt = null;
    item = json['item'];
    quantity = json['quantity'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['CreatedAt'] = CreatedAt;
    _data['UpdatedAt'] = UpdatedAt;
    _data['DeletedAt'] = DeletedAt;
    _data['item'] = item;
    _data['quantity'] = quantity;
    _data['unit'] = unit;
    return _data;
  }
}