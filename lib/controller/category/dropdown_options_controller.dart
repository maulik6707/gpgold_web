import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/dropdown_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DropdownOptionsController extends GetxController {
  var isLoading = false.obs;
  var categoryId = '';
  var orderFieldId = '';
  var isGeneral = false;

  var arrDropdowns = <DropdownModel>[].obs;

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  Future<dynamic> getDropdowns() async {

    try {
      isLoading(true);

      print("Get Dropdown url ${API.getDropdownOption}${isGeneral ? 'general' : 'order'}/$orderFieldId?api_key=123456789");

      final response = await http.get(Uri.parse('${API.getDropdownOption}${isGeneral ? 'general' : 'order'}/$orderFieldId?api_key=123456789'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get Dropdown response $responseBody");

      if (response.statusCode == 200) {
        isLoading(false);
        arrDropdowns.value = List.from(responseBody['options']).map<DropdownModel>((item) => DropdownModel.fromJson(item)).toList();
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