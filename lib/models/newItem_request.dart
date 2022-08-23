class NewitemRequest {
  NewitemRequest({
    required this.Itemname,
    required this.Itemprice,
    required this.Sidedishes,
    required this.Itemquantity,
    required this.Itemstatus,
  });
  late final String Itemname;
  late final String Itemprice;
  late final String Sidedishes;
  late final String Itemquantity;
  late final bool Itemstatus;

  NewitemRequest.fromJson(Map<String, dynamic> json) {
    Itemname = json['Itemname'];
    Itemprice = json['Itemprice'];
    Sidedishes = json['Sidedishes'];
    Itemquantity = json['Itemquantity'];
    Itemstatus = json['Itemstatus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Itemname'] = Itemname;
    _data['Itemprice'] = Itemprice;
    _data['Sidedishes'] = Sidedishes;
    _data['Itemquantity'] = Itemquantity;
    _data['Itemstatus'] = Itemstatus;
    return _data;
  }
}
