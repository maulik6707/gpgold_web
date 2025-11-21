import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddClientController extends GetxController {
  var isLoading = false.obs;
  var dob = DateTime.now().obs;
  var anniversaryDate = DateTime.now().obs;

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  Future<dynamic> register(Map<String, String> bodyParams) async {

    try {
      isLoading(true);

      print("Register url ${API.register}&role=admin");

      final response = await http.post(Uri.parse("${API.register}&role=admin"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Register response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        return responseBody;
      } else {
        isLoading(false);
        ShowToast.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading(false);
      ShowToast.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading(false);
      ShowToast.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading(false);
      debugPrint(e.toString());
    }
  }

  Future<dynamic> sendCode(Map<String, String> bodyParams) async {

    try {
      isLoading(true);

      print("Send code url ${API.requestOtp}");

      final response = await http.post(Uri.parse(API.requestOtp),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Send code response ${responseBody}");
      print("Send code response ${response.statusCode}");
      if (response.statusCode == 200) {
        isLoading(false);
        return responseBody;
      } else {
        isLoading(false);
        ShowToast.showToast('Something went wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading(false);
      ShowToast.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading(false);
      ShowToast.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading(false);
      debugPrint(e.toString());
    }
  }

}