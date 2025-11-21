import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/category_order_field_model.dart';
import 'package:gdgold/model/dropdown_model.dart';
import 'package:gdgold/model/general_order_field_model.dart';
import 'package:gdgold/model/order_model.dart';
import 'package:gdgold/service/api.dart';
import 'package:get/get.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CreateOrderStepTwoController extends GetxController {
  var isLoading = false.obs;
  var deliveryDate = DateTime.now().obs;
  var arrSize = ["2.5", "2.6", "2.7"].obs;
  var arrKarat = ["18", "20", "22", "24"].obs;
  var arrPriority = ["CUSTOMER ORDER", "STOCK ORDER"].obs;
  var arrGeneralFields = <GeneralOrderFieldModel>[].obs;
  var arrCategoryOrderField = <CategoryOrderFieldModel>[].obs;
  var categoryId = "";
  var isEdit = false;
  var isEditImage = false.obs;

  var arrGeneralFieldControllers = <TextEditingController>[].obs;
  var arrCategoryFieldControllers = <TextEditingController>[].obs;
  var selectedPriority = "CUSTOMER ORDER".obs;
  late OrderModel orderDetail;
  Map<String, dynamic> userMap = <String, dynamic>{}.obs;
  var bufferDays = 0;
  List<Map<String, dynamic>> generalFields = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> fields = <Map<String, dynamic>>[].obs;

  // final ImagePicker imagePicker = ImagePicker();
  final _picker = HLImagePicker();

  List<File> arrImages = <File>[].obs;
  List<String> arrEditImages = [];
  Map<String, dynamic> clientDetail = <String, dynamic>{}.obs;

  @override
  void onInit() {
    isLoading(false);
    // getGeneralOrderField();
    getLoggedInUser();
    getBufferDays();
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

  void openPicker(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    if (isCamera) {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (arrImages.length < 5) {
          arrImages.add(File(photo.path));

          print("arrImages ${arrImages}");

          if (isEdit) {
            if (arrImages.isNotEmpty) {
              isEditImage.value = true;
            }
          }
        } else {
          ShowToast.showToast('You can only select up to 5 images');

        }

        print("images ${arrImages.toString()}");
        print("isEdit ${isEdit.toString()}");

      }
    } else {

      final List<XFile?> images = await picker.pickMultiImage(limit: 5 - arrImages.length);

      print("images ${images.toString()}");
      print("isEdit ${isEdit.toString()}");
      for (var element in images) {
        if (element != null) {
          print("arrImages ${arrImages.length}");
          arrImages.add(File(element.path));

        }

      }

      print("arrImages ${arrImages}");

      if (isEdit) {
        if (arrImages.isNotEmpty) {
          isEditImage.value = true;
        }
      }
    }





    // final images = await _picker.openPicker(
    //   pickerOptions: HLPickerOptions(
    //     mediaType: MediaType.image,
    //     enablePreview: false,
    //     thumbnailCompressFormat: CompressFormat.jpg,
    //     thumbnailCompressQuality: 0.5,
    //     maxSelectedAssets: 5 - arrImages.length,
    //     isGif: true,
    //   ),
    // );

  }

  // void pickMultipleImages() async {
  //   final result = await imagePicker.pickMultiImage();
  //
  //   if (result.isNotEmpty) {
  //     arrImages.addAll(result.map((xfile) => File(xfile.path)));
  //   }
  // }

  // void pickFromCamera() async {
  //   final XFile? pickedFile =
  //   await imagePicker.pickImage(source: ImageSource.camera);
  //
  //   if (pickedFile != null) {
  //     arrImages.add(File(pickedFile.path));
  //   }
  // }

  Future<dynamic> getGeneralOrderField() async {

    try {
      isLoading(true);

      print("Get General Field url ${API.getGeneralOrderField}");

      final response = await http.get(Uri.parse(API.getGeneralOrderField),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Get General Field response ${responseBody}");

      if (response.statusCode == 200) {
        // isLoading(false);
        generalFields.clear();
        arrGeneralFields.clear();
        arrGeneralFields.value = List.from(responseBody['fields']).map<GeneralOrderFieldModel>((item) => GeneralOrderFieldModel.fromJson(item)).toList();

        for (int i = 0; i < arrGeneralFields.length; i++) {
          Map<String, dynamic> field = {};
          field['key'] = arrGeneralFields[i].name ?? '';
          field['value'] = '';
          field['selectedValue'] = '';
          field['required'] = "${arrGeneralFields[i].required ?? 0}";
          field['type'] = arrGeneralFields[i].type ?? '';

          if (isEdit) {
            List<String> allFields = orderDetail.extraGeneralFields!.where((e) => e.name != null).map((e) => e.name!.toString()).toList();
            if (allFields.contains(arrGeneralFields[i].name ?? '')) {
              field['controller'] = TextEditingController(text: orderDetail.extraGeneralFields![orderDetail.extraGeneralFields!.indexWhere((e) => e.name == (arrGeneralFields[i].name ?? ''))].value);
            } else {
              field['controller'] = TextEditingController(text: '');
            }
          } else {
            field['controller'] = TextEditingController(text: '');
          }

          if (arrGeneralFields[i].type == 'dropdown' && arrGeneralFields[i].dropDownOptions.toString() != "null") {
            field['dropDownOptions'] = List<String>.from(arrGeneralFields[i].dropDownOptions as List).map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList();

            if (isEdit) {
              List<String> allFields = orderDetail.extraGeneralFields!.where((e) => e.name != null).map((e) => e.name!.toString()).toList();
              if (allFields.contains(arrGeneralFields[i].name ?? '')) {
                field['selectedValue'] = orderDetail.extraGeneralFields![orderDetail.extraGeneralFields!.indexWhere((e) => e.name == (arrGeneralFields[i].name ?? ''))].value;
              } else {
                field['selectedValue'] = field['dropDownOptions'][0].value.toString();
              }
            } else {
              field['selectedValue'] = field['dropDownOptions'][0].value.toString();
            }
          }
          generalFields.add(field);
        }

        print("generalFields ${generalFields.toString()}");
        getCategoryOrderField();
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

  Future<dynamic> getCategoryOrderField() async {

    try {
      isLoading(true);

      print("Get Category Field url ${API.getCategoryOrderField}$categoryId?api_key=123456789");

      final response = await http.get(Uri.parse('${API.getCategoryOrderField}$categoryId?api_key=123456789'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("Get Category Field response ${responseBody}");

      if (response.statusCode == 200) {

        fields.clear();
        arrCategoryOrderField.clear();
        arrCategoryOrderField.value = List.from(responseBody['fields']).map<CategoryOrderFieldModel>((item) => CategoryOrderFieldModel.fromJson(item)).toList();

        print("arrCategoryOrderField ${arrCategoryOrderField.length}");
        for (int i = 0; i < arrCategoryOrderField.length; i++) {
          Map<String, dynamic> field = {};

          field['key'] = arrCategoryOrderField[i].name ?? '';
          field['value'] = '';
          field['selectedValue'] = '';
          field['required'] = "${arrCategoryOrderField[i].required ?? 0}";
          field['type'] = arrCategoryOrderField[i].type ?? '';

          if (isEdit) {
            List<String> allFields = orderDetail.extraOrdersFields!.where((e) => e.name != null).map((e) => e.name!.toString()).toList();
            if (allFields.contains(arrCategoryOrderField[i].name ?? '')) {
              field['controller'] = TextEditingController(text: orderDetail.extraOrdersFields![orderDetail.extraOrdersFields!.indexWhere((e) => e.name == (arrCategoryOrderField[i].name ?? ''))].value);
            } else {
              field['controller'] = TextEditingController(text: '');
            }
          } else {
            field['controller'] = TextEditingController(text: '');
          }

          if (arrCategoryOrderField[i].type == 'dropdown' && arrCategoryOrderField[i].dropDownOptions.toString() != "null") {

            field['dropDownOptions'] = List<String>.from(arrCategoryOrderField[i].dropDownOptions as List).map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList();

            if (isEdit) {

              List<String> allFields = orderDetail.extraOrdersFields!.where((e) => e.name != null).map((e) => e.name!.toString()).toList();

              if (allFields.contains(arrCategoryOrderField[i].name ?? '')) {
                field['selectedValue'] = orderDetail.extraOrdersFields![orderDetail.extraOrdersFields!.indexWhere((e) => e.name?.toLowerCase() == (arrCategoryOrderField[i].name ?? '').toLowerCase())].value;
              } else {
                field['selectedValue'] = field['dropDownOptions'][0].value.toString();
              }
            } else {
              field['selectedValue'] = field['dropDownOptions'][0].value.toString();
            }
          }

          fields.add(field);
        }
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

  Future<dynamic> getBufferDays() async {

    try {
      isLoading(true);

      print("Get Buffer Days url ${API.addBufferDays}");

      final response = await http.get(Uri.parse(API.addBufferDays),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': await SharPreferences.getString('AccessToken') ?? ""
        },);

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("Get Buffer Days response ${await SharPreferences.getString('AccessToken') ?? ""}");
      print("Get Buffer Days response ${responseBody}");

      if (response.statusCode == 200) {
        isLoading(false);
        bufferDays = responseBody['buffer_days']['days'];
        deliveryDate.value = DateTime.now().add(Duration(days: bufferDays));
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

  Future<dynamic> createOrder(Map<String, dynamic> bodyParams) async {

    try {
      isLoading(true);

      print("Add Order url ${API.addOrder}");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.addOrder),
      );

      arrImages.asMap().forEach((index, img) {
        print("img.path request ${img.path.toString()}");
        request.files.add(http.MultipartFile.fromBytes('img${index + 1}', File(img.path).readAsBytesSync(), filename: img.path.split("/").last));
      });
      var arrKeys = bodyParams.keys;

      for (var element in arrKeys) {
        print("'$element': ${ bodyParams['$element'].toString()}");

        if (element == 'extraGeneralFields' || element == 'extraOrdersFields') {
          request.fields['$element'] = jsonEncode(bodyParams['$element']);
        } else {
          request.fields['$element'] = bodyParams['$element'].toString();
        }
      }
      print("arrKeys request ${request.files.toString()}");
      print("arrKeys request ${request.fields.toString()}");

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': await SharPreferences.getString('AccessToken') ?? ""
      };
      request.headers.addAll(requestHeaders);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("responseBody ${responseBody}");
      Map<String, dynamic> responseOrder = jsonDecode(responseBody);

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

  Future<dynamic> updateOrder(Map<String, dynamic> bodyParams) async {

    final tempDir = await getTemporaryDirectory();
    List<File> downloadedFiles = [];
    var index = 0;

    try {
      isLoading(true);

      print("Update Order url ${"${API.addOrder}&update=1"}");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${API.addOrder}&update=1"),
      );

      if ((isEditImage.value)) {
        arrImages.asMap().forEach((index, img) {
          print("img.path request ${img.path.toString()}");
          request.files.add(http.MultipartFile.fromBytes('img${index + 1}', File(img.path).readAsBytesSync(), filename: img.path.split("/").last));
        });
      } else {
        if (arrEditImages.isNotEmpty) {

          // Step 1: Download and attach each image
          for (String imageUrl in arrEditImages) {
            index = index + 1;
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              final fileName = basename(imageUrl);
              final filePath = '${tempDir.path}/$fileName';
              final file = File(filePath);
              await file.writeAsBytes(response.bodyBytes);

              downloadedFiles.add(file); // Save for later deletion
              request.files.add(await http.MultipartFile.fromPath(
                'img$index', // Your backend should accept array field like 'images[]'
                file.path,
              ));

              print('Added image: $fileName');
            } else {
              print('Failed to download image from $imageUrl');
            }
          }
        }
      }



      var arrKeys = bodyParams.keys;
      print("arrKeys $arrKeys=");
      for (var element in arrKeys) {
        print("$element=");
        print("${ bodyParams['$element'].toString()}");

        if (element == 'extraGeneralFields' || element == 'extraOrdersFields') {
          request.fields['$element'] = jsonEncode(bodyParams['$element']);
        } else {
          request.fields['$element'] = bodyParams['$element'].toString();
        }
      }
      print("arrKeys request ${request.files.toString()}");
      print("arrKeys request ${request.fields.toString()}");

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': await SharPreferences.getString('AccessToken') ?? ""
      };
      request.headers.addAll(requestHeaders);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Update order response ${responseBody}");
      Map<String, dynamic> responseOrder = jsonDecode(responseBody);
      print("Update order response ${responseOrder}");

      for (final file in downloadedFiles) {
        if (await file.exists()) {
          await file.delete();
          print('Deleted local file: ${file.path}');
        }
      }

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

  Future<dynamic> sendNotificationOfNewOrder(String orderID, String token, Map<String, dynamic> notificationData) async {
    try {
      isLoading(true);

      var getServerAccessToken = await SharPreferences.getString('FirebaseServerToken') ?? "";

      print("getServerAccessToken $getServerAccessToken");
      print("notificationData $notificationData");
      print("orderID $orderID");

      final response = await http.post(Uri.parse("https://fcm.googleapis.com/v1/projects/gpgold-91ad9/messages:send"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $getServerAccessToken',
          },
          body: jsonEncode({
            "message":{
              "token":token,
              "notification": notificationData
            }
          }));

      print("notification response ${response.body}");

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("notification response ${responseBody}");
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

  getAdminId(String orderID) async {
    isLoading(true);
    await FirebaseFirestore.instance.collection("adminFCMToken").get().then((event) {
      event.docs.forEach((doc) {
        final data = doc.data();
        setNotificationDataOnDatabase(data['adminId'], orderID);
        sendNotificationOfNewOrder(orderID, data['adminToken'], {
          "title":"Order no $orderID",
          "body":"New Order"
        });
      });
      isLoading(false);
    });
  }

  setNotificationDataOnDatabase(int adminId, String orderID) async {
    var notificationId = "${DateTime.now().microsecondsSinceEpoch}";
    await FirebaseFirestore.instance
        .collection("notification")
        .doc("$adminId")
        .collection("notifications")
        .doc(notificationId)
        .set({
      'notificationId': notificationId,
      'orderID': orderID,
      'message': "New Order Received From ${userMap['full_name']}",
      'isRead': false,
    });
  }
}