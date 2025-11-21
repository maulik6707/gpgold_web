import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:http/http.dart' as http;

class BufferDaysController extends GetxController {
  var isLoading = false.obs;
  var bufferDays = 0;
  final bufferDaysController = TextEditingController();

  @override
  void onInit() {
    isLoading(false);
    getBufferDays();
    super.onInit();
  }

  Future<dynamic> getBufferDays() async {

    try {
      isLoading(true);

      print("Get Buffer Days url ${API.addBufferDays}");

      final response = await http.get(Uri.parse(API.addBufferDays),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get Buffer Days response ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Buffer Days response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        bufferDays = responseBody['buffer_days']['days'];
        bufferDaysController.text = "$bufferDays";
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

  Future<dynamic> updateBufferDays(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Buffer days url ${API.addBufferDays}");

      final response = await http.put(Uri.parse(API.addBufferDays),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Buffer days response ${responseBody}");

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