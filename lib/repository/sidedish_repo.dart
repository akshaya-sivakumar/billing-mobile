import 'dart:convert';

import 'package:billing/models/createSidedish_request.dart';
import 'package:billing/models/sidedish_detail.dart';

import '../resources/api_base_helper.dart';

class SidedishRepository {
  Future<List<SidedishDetail>> getSidedish() async {
    var response = await ApiBaseHelper().getMethod("/GetSidedishes/");

    List<SidedishDetail> sidedishResponse = List.from(
        json.decode(response.body).map((e) => SidedishDetail.fromJson(e)));

    return sidedishResponse;
  }

  Future<dynamic> createSidedish(CreateSidedishRequest createRequest) async {
    var response = await ApiBaseHelper()
        .postMethod("/CreateSidedish/", json.encode(createRequest));

    return response;
  }

  Future<dynamic> updateSidedish(
      int id, CreateSidedishRequest updateRequest) async {
    var response = await ApiBaseHelper()
        .putMethod("/UpdateSidedish/$id", json.encode(updateRequest));

    return response;
  }

  Future<dynamic> deleteSidedish(int id) async {
    var response = await ApiBaseHelper().deleteMethod("/DeleteSidedish/$id");

    return response;
  }
}
