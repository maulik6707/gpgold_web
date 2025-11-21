import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/client_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SelectClientController extends GetxController {
  var isLoading = false.obs;
  var arrClients = <ClientModel>[].obs;

  @override
  void onInit() {
    isLoading(false);
    getClients();
    super.onInit();
  }

  Future<dynamic> getClients() async {

    try {
      isLoading(true);

      print("Get Client url ${API.getClient}");

      final response = await http.get(Uri.parse(API.getClient),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Access Token ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Client response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        arrClients.value = List.from(responseBody['clients']).map<ClientModel>((item) => ClientModel.fromJson(item)).toList();
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