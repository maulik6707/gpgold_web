import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  var isLoading = false.obs;
  var isVerifyLoading = false.obs;
  var isSendCodeLoading = false.obs;
  var genderValue = "".obs;
  var selectedZodiacSign = "".obs;
  var zodiacList = <dynamic>[].obs;
  late Timer timer;
  var codeRemainingSeconds = 30.obs;
  var isTimerOn = false.obs;
  var showPassword = false.obs;
  var confirmShowPassword = false.obs;

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
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