import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/client_model.dart';
import 'package:gdgold/model/karigar_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SelectKarigarController extends GetxController {
  var isLoading = false.obs;
  var arrKarigar = <KarigarModel>[].obs;
  var isFromFilter = false;
  var orderId = '';

  @override
  void onInit() {
    isLoading(false);
    getKarigar();
    super.onInit();
  }

  Future<dynamic> getKarigar() async {

    try {
      isLoading(true);

      print("Get Karigar url ${API.getKarigar}");

      final response = await http.get(Uri.parse(API.getKarigar),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get Karigar response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        arrKarigar.value = List.from(responseBody['karigars']).map<KarigarModel>((item) => KarigarModel.fromJson(item)).toList();
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

  Future<dynamic> assignKarigar(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Assign Karigar url ${"${API.assignKarigar}/$orderId/assign-karigar?api_key=123456789"}");

      final response = await http.put(Uri.parse("${API.assignKarigar}/$orderId/assign-karigar?api_key=123456789"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Assign Karigar response ${responseBody}");

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