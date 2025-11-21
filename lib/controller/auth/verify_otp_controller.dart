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

class VerifyOtpController extends GetxController {
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
    isTimerOn.value = true;
    startTimer();
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


  getAdminId(String name) async {
    isLoading(true);
    await FirebaseFirestore.instance.collection("adminFCMToken").get().then((event) {
      event.docs.forEach((doc) {
        final data = doc.data();
        sendNotificationOfNewOrder(data['adminToken'], name);
      });
      isLoading(false);
    });
  }

  Future<dynamic> sendNotificationOfNewOrder(String adminToken, String name) async {
    try {
      isLoading(true);

      var getServerAccessToken = await SharPreferences.getString('FirebaseServerToken') ?? "";

      print("getServerAccessToken $getServerAccessToken");

      final response = await http.post(Uri.parse("https://fcm.googleapis.com/v1/projects/gpgold-91ad9/messages:send"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $getServerAccessToken',
          },
          body: jsonEncode({
            "message":{
              "token": adminToken,
              "notification":{
                "body":"$name requested",
                "title":"New User request"
              }
            }
          }));

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("responseBody1 ${responseBody}");
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

  Future<dynamic> register(Map<String, String> bodyParams) async {

    try {
      isLoading(true);

      print("Register url ${API.register}");

      final response = await http.post(Uri.parse(API.register),
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
}