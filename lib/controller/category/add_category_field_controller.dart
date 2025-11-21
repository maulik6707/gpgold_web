import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gdgold/pages/auth/login_screen.dart';

class AddCategoryFieldController extends GetxController {
  var isLoading = false.obs;
  var selectedTypeKey = "shorttext".obs;
  var selectedTypeValue = "Short Text".obs;
  var selectedRequiredValue = "Yes".obs;
  var selectedClientFormValue = "Yes".obs;

  var arrDropDownFields = [
    const DropdownMenuItem(
      value: 'Short Text',
      child: Text('Short Text'),),
    const DropdownMenuItem(
      value: 'Large Text',
      child: Text('Large Text'),),
    const DropdownMenuItem(
      value: 'Dropdown Options',
      child: Text('Dropdown Options'),),
    const DropdownMenuItem(
      value: "Declined",
      child: Text("Declined"),),
    const DropdownMenuItem(
      value: 'Range Text Details',
      child: Text('Range Text Details'),),
  ].obs;

  var arrRequiredDropDownFields = [
    const DropdownMenuItem(
      value: 'Yes',
      child: Text('Yes'),),
    const DropdownMenuItem(
      value: 'No',
      child: Text('No'),),
  ].obs;
  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  Future<dynamic> addCategoryOrderField(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Add Category Order Field url ${API.addCategoryOrderField}");

      final response = await http.post(Uri.parse(API.addCategoryOrderField),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Add Category Order Field response ${responseBody}");

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

  Future<dynamic> addGeneralOrderField(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Add General Order Field url ${API.addGeneralOrderField}");

      final response = await http.post(Uri.parse(API.addGeneralOrderField),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Add General Order Field response ${responseBody}");

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

  Future<dynamic> editGeneralOrderField(Map<String, dynamic> bodyParams, String generalFieldId) async {

    try {
      isLoading(true);

      print("Edit General Order Field url ${API.addGeneralOrderField}&id=$generalFieldId");

      final response = await http.put(Uri.parse("${API.addGeneralOrderField}&id=$generalFieldId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Edit General Order Field response ${responseBody}");

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