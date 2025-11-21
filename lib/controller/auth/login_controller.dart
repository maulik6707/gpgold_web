import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var isLoading = false.obs;
  var genderValue = "".obs;
  var selectedZodiacSign = "".obs;
  var zodiacList = <dynamic>[].obs;
  late Timer timer;
  var codeRemainingSeconds = 30.obs;
  var isTimerOn = false.obs;
  var showPassword = false.obs;

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  void startTimer() {
    codeRemainingSeconds.value = 30;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (codeRemainingSeconds.value == 0) {
          isTimerOn.value = false;
          timer.cancel();
        } else {
          codeRemainingSeconds--;
        }
      },
    );
  }

  Future<dynamic> login(Map<String, String> bodyParams) async {

    try {
      isLoading(true);

      print("Login url ${API.login}");

      final response = await http.post(Uri.parse(API.login),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

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

  Future<dynamic> updateClientForNotification(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("URL ${API.getClient}");

      final response = await http.post(Uri.parse(API.getClient),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));
      print("Update PLayer id response ${response.body}");
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Update PLayer id response ${responseBody}");
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