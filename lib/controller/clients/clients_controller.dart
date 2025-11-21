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

class ClientsController extends GetxController {
  var isLoading = false.obs;
  var currentPage = 1;
  bool hasMoreData = true;
  var arrClients = <ClientModel>[].obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    isLoading(false);
    getClients('&page=${currentPage}&limit=20');
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !(isLoading.value) &&
          hasMoreData) {
        getClients('&page=${currentPage}&limit=20');
      }
    });
    super.onInit();
  }

  Future<dynamic> getClients(String utility) async {

    try {
      if (!(utility.contains("search"))) {
        isLoading(true);
      }
      arrClients.clear();

      print("Get Client url ${API.getClient + utility}");

      final response = await http.get(Uri.parse(API.getClient + utility),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Access Token ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Client response ${responseBody}");

      if (response.statusCode == 200) {
        if (!(utility.contains("search"))) {
          isLoading(false);
        }

        List<ClientModel> clients = List.from(responseBody['clients']).map<ClientModel>((item) => ClientModel.fromJson(item)).toList();

        if (utility.contains("search")) {
          arrClients.clear();
        }

        arrClients.addAll(clients);
        if (clients.isEmpty) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        return responseBody;
      } else if (response.statusCode == 401) {
        ShowToast.showToast("Login again");
        Get.offAll(LoginScreen());
      } else {
        if (!(utility.contains("search"))) {
          isLoading(false);
        }
        if (responseBody['message'].toString().isNotEmpty) {
          ShowToast.showToast(responseBody['message'].toString());
        } else {
          ShowToast.showToast('Something went wrong. Please try again later');
          throw Exception('Failed to load album');
        }
      }
    } on TimeoutException catch (e) {
      if (!(utility.contains("search"))) {
        isLoading(false);
      }
      ShowToast.showToast(e.message.toString());
    } on SocketException catch (e) {
      if (!(utility.contains("search"))) {
        isLoading(false);
      }
      ShowToast.showToast(e.message.toString());
    } on Error catch (e) {
      if (!(utility.contains("search"))) {
        isLoading(false);
      }
      debugPrint(e.toString());
    }
  }

  Future<dynamic> deactivateClient(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Deactivate Client url ${API.deactivateClient}");

      final response = await http.put(Uri.parse(API.deactivateClient),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Access Token ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Deactivate Client response ${responseBody}");

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

  Future<dynamic> deleteClient(int id) async {

    try {
      isLoading(true);

      print("Delete Client Category url ${API.getClient}");

      final response = await http.delete(Uri.parse("${API.getClient}&id=$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Delete Client response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        getClients('&page=1&limit=20');
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