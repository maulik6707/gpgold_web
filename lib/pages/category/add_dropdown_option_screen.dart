import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/category/add_dropdown_option_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class AddDropdownOptionScreen extends StatelessWidget {
  AddDropdownOptionScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final addDropdownOptionController = Get.put(AddDropdownOptionController());

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      if (Get.arguments['isGeneral']!= null && Get.arguments['isGeneral']) {
        addDropdownOptionController.isGeneral = true;
        addDropdownOptionController.orderFieldId = Get.arguments['orderFieldId'].toString();
      } else {
        addDropdownOptionController.categoryId = Get.arguments['categoryId'].toString();
        addDropdownOptionController.orderFieldId = Get.arguments['orderFieldId'].toString();
      }
    }
    return GetX<AddDropdownOptionController>(
      init: AddDropdownOptionController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.addOption, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                          child: Text('- ${AppLocalizations.of(context)!.option}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
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
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GestureDetector(
                            onTap: () {

                              Map<String, dynamic> bodyParams = {};
                              if (controller.isGeneral) {
                                bodyParams = {
                                  "dropDownOptionName": nameController.text.trim(),
                                  "categoryId": null,
                                  "generalFieldId": controller.orderFieldId,
                                  "orderFieldId": null,
                                };
                              } else {
                                bodyParams = {
                                  "dropDownOptionName": nameController.text.trim(),
                                  "categoryId": controller.categoryId,
                                  "generalFieldId": null,
                                  "orderFieldId": controller.orderFieldId,
                                };
                              }

                              print("Add general order field params ${bodyParams}");

                              controller.addDropdownOptions(bodyParams).then((response) {
                                if (response['success'].toString() == "true") {
                                  Get.back(result: "added");
                                  ShowToast.showToast(response['message'].toString());
                                } else {
                                  ShowToast.showToast(response['message'].toString());
                                }
                              });
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