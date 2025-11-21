import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/category/add_category_controller.dart';
import '../../l10n/app_localizations.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<AddCategoryController>(
      init: AddCategoryController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.addCategory, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              centerTitle: true,
              backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ConstantColor.gradientTopColor, ConstantColor.gradientTopColor],
                    stops: [0.0, 0.80]
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.categoryName}: *', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text('- ${AppLocalizations.of(context)!.remarks}:', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          SizedBox(
                            height: 100,
                            child: TextFormField(
                              maxLines: 3,
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                labelText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white), //<-- SEE HERE
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                              controller: remarksController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                if (nameController.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterCategoryName);
                                } else {
                                  Map<String, String> bodyParams = {
                                    "name": nameController.text,
                                    "remarks": remarksController.text,
                                  };
                                  print("Add Category params ${bodyParams}");

                                  controller.addCategory(bodyParams).then((response) {
                                    if (response['success'].toString() == "true") {
                                      Get.back(result: "added");
                                      ShowToast.showToast(response['message'].toString());
                                    } else {
                                      ShowToast.showToast(response['message'].toString());
                                    }
                                  });
                                }
                              },
                              child: Container(
                                  height: 60,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.white, width: 1),
                                      color: Colors.white
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  child: Center(child: Text(AppLocalizations.of(context)!.submit, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(child: controller.isLoading.value ? const Loader() : Container())
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}