import 'dart:convert';

import 'package:billing/models/sidedish_detail.dart';

import '../resources/api_base_helper.dart';

class SidedishRepository {
  Future<List<SidedishDetail>> getSidedish() async {
    var response = await ApiBaseHelper().getMethod("/GetSidedishes/");

    List<SidedishDetail> sidedishResponse = List.from(
        json.decode(response.body).map((e) => SidedishDetail.fromJson(e)));

    return sidedishResponse;
  }
}
