import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/order_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrdersController extends GetxController with WidgetsBindingObserver {
  var isLoading = false.obs;
  var currentPage = 1;
  bool hasMoreData = true;
  var selectedStatusValue = "All".obs;
  var filterUrl = '';

  var arrOrder = <OrderModel>[].obs;
  Map<String, dynamic> userMap = <String, dynamic>{}.obs;
  var arrFields = ["All", 'New Order', 'In Process', 'Order Ready', 'Declined', 'Customer Cancelled', 'Delivered'].obs;
  var arrFieldsValue = ['5', '11', '17', '8', '0', '1'].obs;
  var arrDropDownFields = [
    const DropdownMenuItem(
    value: "All",
    child: Text("All"),),
    const DropdownMenuItem(
    value: "New order",
    child: Text("New order"),),
    const DropdownMenuItem(
    value: "In process",
    child: Text("In process"),),
    const DropdownMenuItem(
    value: "Order ready",
    child: Text("Order ready"),),
    const DropdownMenuItem(
    value: "Declined",
    child: Text("Declined"),),
    const DropdownMenuItem(
    value: "Customer cancelled",
    child: Text("Customer cancelled"),),
    const DropdownMenuItem(
    value: "Delivered",
    child: Text("Delivered"),),
  ].obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    isLoading(false);
    getLoggedInUser();
    WidgetsBinding.instance.addObserver(this);

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !(isLoading.value) &&
          hasMoreData) {
        print("pagination");
        if (selectedStatusValue.value.replaceAll(" ", "_").toLowerCase() == 'all') {
          getOrders(filterUrl.isEmpty ? '&page=${currentPage}&limit=20' : '$filterUrl&page=${currentPage}&limit=20');
        } else {
          getOrders(filterUrl.isEmpty ? '&page=${currentPage}&limit=20&status=${selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}' : '$filterUrl&page=${currentPage}&limit=20&status=${selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}');
        }
      }
    });


    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

    }
  }


  Future<dynamic> getLoggedInUser() async {
    final String? user = await SharPreferences.getString('LoggedInUser');
    if (user != null) {
      userMap = jsonDecode(user);
      // getOrders('');
    }
  }


  Future<dynamic> getOrders(String utility) async {

    try {
      isLoading(true);

      var url = userMap['role'] != 'client' ? "${API.addOrder}$utility" : "${API.addOrder}&clientId=${userMap['id']}$utility";

      print("Get Order url $url");

      final response = await http.get(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Access Token ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Order response ${responseBody}");
      if (response.statusCode == 200) {
        isLoading(false);
        List<OrderModel> orders = List.from(responseBody['orders']).map<OrderModel>((item) => OrderModel.fromJson(item)).toList();
        arrOrder.addAll(orders);

        if (orders.isEmpty) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

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