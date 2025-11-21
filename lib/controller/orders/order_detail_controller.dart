import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/model/karigar_model.dart';
import 'package:gdgold/model/order_model.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;

class OrderDetailController extends GetxController {
  var isLoading = false.obs;
  final pdf = pw.Document();

  final List<pw.TableRow> arrRows = [];
  List<OrderFieldModel> arrOrderFields = [];
  var orderId = "";

  var selectedStatusValue = "New order".obs;
  var arrDropDownFields = [
    const DropdownMenuItem(
      value: "New order",
      child: Text("New order"),
    ),
    const DropdownMenuItem(
      value: "In process",
      child: Text("In process"),
    ),
    const DropdownMenuItem(
      value: "Order ready",
      child: Text("Order ready"),
    ),
    const DropdownMenuItem(
      value: "Declined",
      child: Text("Declined"),
    ),
    const DropdownMenuItem(
      value: "Customer cancelled",
      child: Text("Customer cancelled"),
    ),
    const DropdownMenuItem(
      value: "Delivered",
      child: Text("Delivered"),
    ),
  ].obs;

  late OrderModel orderDetail;
  var arrKarigar = <KarigarModel>[].obs;
  Map<String, dynamic> userMap = <String, dynamic>{}.obs;

  List<String> arrImages = [];

  List<Map<String, dynamic>> arrData = [
    {"name": "carat", "value": "22.7"},
    {"name": "material", "value": "gold"},
    {"name": "weight", "value": "22.5"},
    {"name": "size", "value": "100"},
    {"name": "length", "value": "10"}
  ];

  @override
  void onInit() {
    isLoading(false);
    getKarigar();
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

      final response = await http.get(
        Uri.parse(API.getKarigar),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get Karigar response $responseBody");

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

  Future<dynamic> getOrderDetail(bool isNotification) async {
    try {
      isLoading(true);
      arrImages.clear();
      arrOrderFields.clear();
      arrRows.clear();

      var apiUrl = isNotification
          ? "${API.assignKarigar}/$orderId?api_key=123456789"
          : "${API.assignKarigar}/${orderDetail.order_no!.split("/").last}?api_key=123456789";

      print("Get orderDetail url $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get orderDetail response $responseBody");

      if (response.statusCode == 200) {
        isLoading(false);
        orderDetail = OrderModel.fromJson(responseBody['order']);

        selectedStatusValue.value = orderDetail.status!.capitalizeFirst!.replaceAll("_", " ");
        arrOrderFields.add(OrderFieldModel(name: 'Order No', value: orderDetail.order_no ?? ''));
        arrOrderFields.add(OrderFieldModel(name: 'Order Date', value: orderDetail.orderDate ?? ''));
        arrOrderFields.add(OrderFieldModel(name: 'Deliver Date', value: orderDetail.deliveryDate ?? ''));
        arrOrderFields.add(OrderFieldModel(name: 'Priority', value: orderDetail.priority ?? ''));
        arrOrderFields.add(OrderFieldModel(name: 'Category', value: orderDetail.category ?? ''));
        arrOrderFields.add(OrderFieldModel(name: 'Status', value: orderDetail.status ?? ''));
        arrOrderFields.add(OrderFieldModel(name: 'Remark', value: orderDetail.remarks ?? ''));

        if (orderDetail.img1 != null && orderDetail.img1.toString() != "null") {
          arrImages.add(orderDetail.img1 ?? '');
        }

        if (orderDetail.img2 != null && orderDetail.img2.toString() != "null") {
          arrImages.add(orderDetail.img2 ?? '');
        }

        if (orderDetail.img3 != null && orderDetail.img3.toString() != "null") {
          arrImages.add(orderDetail.img3 ?? '');
        }

        if (orderDetail.img4 != null && orderDetail.img4.toString() != "null") {
          arrImages.add(orderDetail.img4 ?? '');
        }

        if (orderDetail.img5 != null && orderDetail.img5.toString() != "null") {
          arrImages.add(orderDetail.img5 ?? '');
        }

        if (orderDetail.extraGeneralFields != null && orderDetail.extraGeneralFields!.isNotEmpty) {
          orderDetail.extraGeneralFields?.forEach((field) {
            arrOrderFields.add(field);
          });
        }

        if (orderDetail.extraOrdersFields != null && orderDetail.extraOrdersFields!.isNotEmpty) {
          orderDetail.extraOrdersFields?.forEach((field) {
            arrOrderFields.add(field);
          });
        }

        for (int i = 0; i < arrOrderFields.length; i += 2) {
          final first = arrOrderFields[i];
          final second = (i + 1 < arrOrderFields.length) ? arrOrderFields[i + 1] : null;

          arrRows.add(
            pw.TableRow(
              children: [
                tableCell("${first.name}: ${first.value}"),
                tableCell(second != null ? "${second.name}: ${second.value}" : ""),
              ],
            ),
          );
        }
      } else if (response.statusCode == 401) {
        ShowToast.showToast("Login again");
        Get.offAll(LoginScreen());
      } else if (response.statusCode == 404) {
        isLoading(false);
        ShowToast.showToast("Something went wrong");
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

  Future<dynamic> changeStatusOfOrder(Map<String, dynamic> bodyParams) async {
    try {
      isLoading(true);

      print("Change Status url ${"${API.assignKarigar}/${orderDetail.order_no?.split("/").last}/status?api_key=123456789"}");

      final response = await http.put(Uri.parse("${API.assignKarigar}/${orderDetail.order_no?.split("/").last}/status?api_key=123456789"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': await SharPreferences.getString('AccessToken') ?? ""
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Change Status response ${responseBody}");

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

  pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(12.0),
      child: pw.Text(text, style: const pw.TextStyle(color: PdfColors.black, fontSize: 14)),
    );
  }

  Future<dynamic> sendNotificationOfNewOrder(String orderID, String token) async {
    try {
      isLoading(true);

      var getServerAccessToken = await SharPreferences.getString('FirebaseServerToken') ?? "";

      final response = await http.post(Uri.parse("https://fcm.googleapis.com/v1/projects/gpgold-91ad9/messages:send"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $getServerAccessToken',
          },
          body: jsonEncode({
            "message": {
              "token": token,
              "notification": {"body": "is in ${selectedStatusValue.value}", "title": "Order no $orderID"}
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

  Future<dynamic> deleteOrder(String id) async {
    try {
      isLoading(true);

      print("Delete Order url ${API.addOrder}");

      final response = await http.delete(
        Uri.parse("${API.addOrder}&id=$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Delete Order response ${responseBody}");

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
