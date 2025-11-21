import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/karigar_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderFilterController extends GetxController {
  var isLoading = false.obs;
  var selectedStatusValue = "All".obs;
  var arrPriority = ["CUSTOMER ORDER", "STOCK ORDER"].obs;
  var arrKarigar = <KarigarModel>[].obs;
  Map<String, dynamic> userMap = <String, dynamic>{}.obs;
  var selectedCategoryName = ''.obs;
  var selectedKarigarName = ''.obs;
  var selectedClientName = ''.obs;
  var selectedCategoryId = 0;
  var selectedKarigarId = '';
  var selectedClientId = '';
  var selectedPriority = "".obs;

  var arrFields = ["All", 'New Order', 'In Process', 'Order Ready', 'Declined', 'Customer Cancelled', 'Delivered'].obs;
  var arrDropDownFields = [
    const DropdownMenuItem(
      value: "All",
      child: Text("All"),),
    const DropdownMenuItem(
      value: "New Order",
      child: Text("New Order"),),
    const DropdownMenuItem(
      value: "In Process",
      child: Text("In Process"),),
    const DropdownMenuItem(
      value: "Order Ready",
      child: Text("Order Ready"),),
    const DropdownMenuItem(
      value: "Declined",
      child: Text("Declined"),),
    const DropdownMenuItem(
      value: "Customer Cancelled",
      child: Text("Customer Cancelled"),),
    const DropdownMenuItem(
      value: "Delivered",
      child: Text("Delivered"),),
  ].obs;

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
      isLoading(false);
      print("userMap ${userMap['full_name']}");
    }
    isLoading(false);
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

}