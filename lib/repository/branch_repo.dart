import 'dart:convert';

import 'package:billing/constants/app_strings.dart';
import 'package:billing/models/branchDetail.dart';
import 'package:billing/models/branch_request.dart';
import 'package:billing/models/login_request.dart';
import 'package:billing/models/login_response.dart';
import 'package:billing/resources/api_base_helper.dart';

class BranchRepository {
  Future<List<BranchDetail>> getBranch() async {
    var response = await ApiBaseHelper().getMethod("/Getallbranch/");

    List<BranchDetail> branchResponse = List.from(
        json.decode(response.body).map((e) => BranchDetail.fromJson(e)));

    return branchResponse;
  }

  Future<dynamic> createBranch(BranchRequest branchRequest) async {
    var response = await ApiBaseHelper()
        .postMethod("/Createbranch/", json.encode(branchRequest));

    return response;
  }

  Future<dynamic> updateBranch(int id, BranchRequest updateRequest) async {
    var response = await ApiBaseHelper()
        .putMethod("/Updatebranch/$id", json.encode(updateRequest));

    return response;
  }

  Future<dynamic> deleteBranch(int id) async {
    var response = await ApiBaseHelper().deleteMethod("/Deletebranch/$id");

    return response;
  }
}
