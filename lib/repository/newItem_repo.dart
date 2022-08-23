import 'dart:convert';

import 'package:billing/models/newItem_request.dart';

import '../resources/api_base_helper.dart';

class NewitemRepository {
  Future<dynamic> createNewitem(NewitemRequest newitemRequest) async {
    var response = await ApiBaseHelper()
        .postMethod("/CreateFooditem/", json.encode(newitemRequest));

    return response;
  }
}
