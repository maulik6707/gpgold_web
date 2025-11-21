import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/notification_model.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var db = FirebaseFirestore.instance;
  Map<String, dynamic> userMap = <String, dynamic>{}.obs;
  var arrNotification = <NotificationModel>[].obs;

  @override
  void onInit() {
    isLoading(false);
    getLoggedInUser();
    
    super.onInit();
  }

  Future<dynamic> getLoggedInUser() async {
    isLoading(true);
    final String? user = await SharPreferences.getString('LoggedInUser');
    if (user != null) {
      userMap = jsonDecode(user);
      getNotificationData();

      print("userMap ${userMap['full_name']}");
    }
    isLoading(false);
  }

  getNotificationData() async {
    await FirebaseFirestore.instance.collection("notification").doc("${userMap['id']}").collection("notifications").get().then((event) {
      print("event.docs ${event.docs.iterator}");
      arrNotification.value = event.docs.map((doc) {
        final data = doc.data();
        return NotificationModel(
          notificationId: data['notificationId'],
          orderID: data['orderID'],
          message: data['message'],
          isRead: data['isRead'],
        );
      }).toList();
      isLoading(false);
    });
  }

  Future<dynamic> registerAPI(Map<String, dynamic> bodyParams) async {
    try {
      isLoading(true);
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
}