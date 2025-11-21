import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;
  var showCurrentPassword = false.obs;
  var showNewPassword = false.obs;
  var showConfirmPassword = false.obs;

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  Future<dynamic> changePassword(Map<String, String> bodyParams) async {

    try {
      isLoading(true);

      print("changePassword url ${API.changePassword}");

      final response = await http.post(Uri.parse(API.changePassword),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("changePassword response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        return responseBody;
      } else if (response.statusCode == 401) {
        ShowToast.showToast("Login again");
        Get.offAll(LoginScreen());
      } else {
        isLoading(false);
        if (responseBody['message'].toString().isNotEmpty) {
          ShowToast.showToast(responseBody['message'].toString());
        } else {
          ShowToast.showToast('Something went wrong. Please try again later');
          throw Exception('Failed to load album');
        }
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