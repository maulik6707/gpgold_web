import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/model/status_count_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var isLoading = false.obs;

  var arrFields = ['New Order', 'In Process', 'Order Ready', 'Declined', 'Customer Cancelled', 'Delivered'].obs;
  var arrFieldsValue = ['5', '11', '17', '8', '0', '1'].obs;
  Map<String, dynamic> userMap = <String, dynamic>{}.obs;
  var arrStatus = <StatusCountModel>[].obs;

  void onResumed() {
    // Called when the screen comes back into focus
    print("Screen resumed. Reloading data...");
    getLoggedInUser();
  }


  @override
  void onInit() {
    isLoading(false);
    getLoggedInUser();
    super.onInit();
  }

  Future<dynamic> sendNotificationOfNewOrder() async {
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
              "token": 'cdRynsj1SpqGYKPuVoft7m:APA91bEmJ96gaC3ky-wtndvCi_iHi6ErewlPfDaj3XMcIhM56HVDZx6NqaV_xBNIKDWfxPWN4eXujdkzpXAUzJ8W8xRX9bUnFWlr9j4NBeJt5OfI3mKfRrA',
              "notification":{
                "body":"is in In Process",
                "title":"Order no 36"
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

  Future<dynamic> getLoggedInUser() async {
    isLoading(true);
    final String? user = await SharPreferences.getString('LoggedInUser');
    if (user != null) {
      userMap = jsonDecode(user);
      getOrderCount();
      isLoading(false);
      print("userMap ${userMap['full_name']}");
    }
    isLoading(false);
  }

  Future<dynamic> getOrderCount() async {

    try {
      isLoading(true);

      var url = userMap['role'] != 'client' ? "${API.addOrder}&clientId=${userMap['id']}&action=status_count" : "${API.addOrder}&clientId=${userMap['id']}&action=status_count";

      print("Get Order Count url $url");

      final response = await http.get(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Access Token ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Order Count  response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        arrStatus.value = List.from(responseBody['status_counts']).map<StatusCountModel>((item) => StatusCountModel.fromJson(item)).toList();
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
      } else if (response.statusCode == 401) {
        ShowToast.showToast("Login again");
        Get.offAll(LoginScreen());
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

  Future<dynamic> deleteClient() async {

    try {
      isLoading(true);

      print("Delete Client Category url ${API.getClient}&id=${userMap['id']}");

      final response = await http.delete(Uri.parse("${API.getClient}&id=${userMap['id']}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Delete Client response ${responseBody}");

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