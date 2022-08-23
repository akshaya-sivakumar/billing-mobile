class CreateSidedishRequest {
  CreateSidedishRequest({
    required this.Item,
    required this.Quantity,
    required this.Unit,
  });
  late final String Item;
  late final String Quantity;
  late final String Unit;
  
  CreateSidedishRequest.fromJson(Map<String, dynamic> json){
    Item = json['Item'];
    Quantity = json['Quantity'];
    Unit = json['Unit'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Item'] = Item;
    _data['Quantity'] = Quantity;
    _data['Unit'] = Unit;
    return _data;
  }
}