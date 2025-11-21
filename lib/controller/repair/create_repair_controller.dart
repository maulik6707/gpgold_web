import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:http/http.dart' as http;

class CreateRepairController extends GetxController {
  var isLoading = false.obs;

  List<File> arrImages = <File>[].obs;
  final _picker = HLImagePicker();

  @override
  void onInit() {
    isLoading(false);
    super.onInit();
  }

  void openPicker() async {
    final images = await _picker.openPicker(
      pickerOptions: HLPickerOptions(
        mediaType: MediaType.image,
        enablePreview: false,
        thumbnailCompressFormat: CompressFormat.jpg,
        thumbnailCompressQuality: 0.5,
        maxSelectedAssets: 5 - arrImages.length,
        isGif: true,
      ),
    );
    for (var element in images) {
      arrImages.add(File(element.path));
    }
  }

  Future<dynamic> createRepair(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Add Repair url ${API.getRepair}");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.getRepair),
      );

      arrImages.asMap().forEach((index, img) {
        print("img.path request ${img.path.toString()}");
        request.files.add(http.MultipartFile.fromBytes('img${index + 1}', File(img.path).readAsBytesSync(), filename: img.path.split("/").last));
      });
      var arrKeys = bodyParams.keys;
      print("arrKeys request ${arrKeys.length.toString()}");

      for (var element in arrKeys) {
        print("'$element': ${ bodyParams['$element'].toString()}");

        request.fields['$element'] = bodyParams['$element'];
      }
      print("arrKeys request ${request.fields.toString()}");

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': await SharPreferences.getString('AccessToken') ?? ""
      };
      request.headers.addAll(requestHeaders);
      print("addOrder request ${request.toString()}");
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseOrder = jsonDecode(responseBody);

      // bodyParams.map(convert)
      //
      // final response = await http.post(Uri.parse(API.addOrder),
      //     headers: <String, String>{
      //       'Content-Type': 'application/json; charset=UTF-8',
      //       'Authorization': await SharPreferences.getString('AccessToken') ?? ""
      //     },
      //     body: jsonEncode(bodyParams));
      //
      // Map<String, dynamic> responseBody = jsonDecode(response.body);
      //
      // print("addOrder response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        return responseOrder;
      } else if (response.statusCode == 401) {
        ShowToast.showToast("Login again");
        Get.offAll(LoginScreen());
      } else {
        isLoading(false);
        // if (responseBody['message'].toString().isNotEmpty) {
        //   ShowToast.showToast(responseBody['message'].toString());
        // } else {
        //   ShowToast.showToast('Something went wrong. Please try again later');
        //   throw Exception('Failed to load album');
        // }
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