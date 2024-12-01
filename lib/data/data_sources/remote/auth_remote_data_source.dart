import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:test_task/core/classes/exceptions.dart';
import 'package:test_task/core/network/api_endpoints.dart';
import 'package:test_task/data/data_sources/local/user_local_data_source.dart';
import 'package:test_task/data/models/response_model.dart' as r;

class AuthRemoteDataSource {
  final UserLocalDataSource _userLocalDataSource =
      Get.find<UserLocalDataSource>();

  Future<r.Response> login(loginData) async {
    log(loginData);
    final http.Response response = await http.post(
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.login),
      body: loginData,
    );
    try {
      log(response.body);
      var data = json.decode(response.body);
      return r.Response.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<r.Response> register(registerData) async {
    log(registerData.toString());
    final http.Response response = await http.post(
      Uri.parse(
          ApiEndpoints.baseUrl + ApiEndpoints.user + ApiEndpoints.register),
      body: registerData,
    );
    try {
      log(response.body);
      var data = json.decode(response.body);
      return r.Response.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<r.Response> changePassword(userData) async {
    String? token = await _userLocalDataSource.getUserToken();
    final http.Response response = await http.post(
      Uri.parse(
          "${ApiEndpoints.baseUrl}${ApiEndpoints.user}${ApiEndpoints.changePassword}"),
      headers: {'Authorization': 'Bearer $token'},
      body: userData,
    );
    try {
      log(response.body);
      var data = json.decode(response.body);
      return r.Response.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
