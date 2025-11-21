import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/category_model.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gdgold/pages/auth/login_screen.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var arrCategory = <CategoryModel>[].obs;

  @override
  void onInit() {
    isLoading(false);
    getCategory();
    super.onInit();
  }

  Future<dynamic> getCategory() async {

    try {
      isLoading(true);

      print("Get Category url ${API.getCategory}");

      final response = await http.get(Uri.parse(API.getCategory),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get Category response ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Category response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        arrCategory.value = List.from(responseBody['categories']).map<CategoryModel>((item) => CategoryModel.fromJson(item)).toList();
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

  Future<dynamic> deleteCategory(int id) async {

    try {
      isLoading(true);

      print("Get Category url ${API.addCategory}");

      final response = await http.delete(Uri.parse("${API.addCategory}&id=$id"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Get Category response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        getCategory();
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