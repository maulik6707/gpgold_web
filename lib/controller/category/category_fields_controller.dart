import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/category_order_field_model.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gdgold/pages/auth/login_screen.dart';

class CategoryFieldsController extends GetxController {
  var isLoading = false.obs;
  var arrCategoryOrderField = <CategoryOrderFieldModel>[].obs;
  var categoryId = "";

  @override
  void onInit() {
    isLoading(false);

    super.onInit();
  }

  Future<dynamic> getCategoryOrderField() async {

    try {
      isLoading(true);

      print("Get Category Field url ${API.getCategoryOrderField}$categoryId?api_key=123456789");

      final response = await http.get(Uri.parse('${API.getCategoryOrderField}$categoryId?api_key=123456789'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Get Category Field response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        arrCategoryOrderField.clear();
        arrCategoryOrderField.value = List.from(responseBody['fields']).map<CategoryOrderFieldModel>((item) => CategoryOrderFieldModel.fromJson(item)).toList();
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

  Future<dynamic> deleteCategoryOrderField(int id) async {

    try {
      isLoading(true);

      print("Delete Category url ${API.addCategoryOrderField}");

      final response = await http.delete(Uri.parse("${API.addCategoryOrderField}&id=$id&categoryId=$categoryId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Delete Category response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        getCategoryOrderField();
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