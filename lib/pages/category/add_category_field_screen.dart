import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/category/add_category_field_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/category_order_field_model.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';

class AddCategoryFieldScreen extends StatelessWidget {
  AddCategoryFieldScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();

  final addCategoryFieldController = Get.put(AddCategoryFieldController());

  @override
  Widget build(BuildContext context) {
    var categoryId = "";
    CategoryOrderFieldModel generalField = CategoryOrderFieldModel();
    var isGeneral = false;
    var isEdit = false;

    if (Get.arguments != null) {
      if (Get.arguments['isGeneral'] != null && Get.arguments['isGeneral']) {
        isGeneral = true;
      } else {
        categoryId = Get.arguments['categoryId'].toString();
      }

      if (Get.arguments['isEdit'] != null && Get.arguments['isEdit']) {
        isEdit = true;
      }

      if (Get.arguments['generalField'] != null) {
        generalField = Get.arguments['generalField'];
        nameController.text = generalField.name ?? '';
        addCategoryFieldController.selectedTypeKey.value = generalField.type ?? '';
        if (addCategoryFieldController.selectedTypeKey.value == "shorttext") {
          addCategoryFieldController.selectedTypeValue.value = 'Short Text';
        } else if (addCategoryFieldController.selectedTypeKey.value == "longtext") {
          addCategoryFieldController.selectedTypeValue.value = "Large Text";
        } else if (addCategoryFieldController.selectedTypeKey.value == "dropdown") {
          addCategoryFieldController.selectedTypeValue.value = "Dropdown Options";
        } else if (addCategoryFieldController.selectedTypeKey.value == "decline") {
          addCategoryFieldController.selectedTypeValue.value = "Declined";
        } else {
          addCategoryFieldController.selectedTypeValue.value = "range";
        }


        addCategoryFieldController.selectedClientFormValue.value = (generalField.isShow ?? 0) == 0 ? "No" : "Yes";
        addCategoryFieldController.selectedRequiredValue.value = (generalField.required ?? 0) == 0 ? "No" : "Yes";
      }
    }

    return GetX<AddCategoryFieldController>(
      init: AddCategoryFieldController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.addCategoryField, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                          child: Text('- ${AppLocalizations.of(context)!.fieldName}: *', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
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
                          padding: const EdgeInsets.only(top: 20, bottom: 0.0),
                          child: Text('- ${AppLocalizations.of(context)!.controlType}: *', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                        ),
                        DropdownButton(
                            value: controller.selectedTypeValue.value,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'Montserrat'),
                            iconEnabledColor: Colors.white,
                            dropdownColor: ConstantColor.primary,
                            isExpanded: true,
                            items: controller.arrDropDownFields,
                            onChanged: (txt) {
                              if (txt == null) return;
                              controller.selectedTypeValue.value = txt;
                              if (txt == 'Short Text') {
                                controller.selectedTypeKey.value = "shorttext";
                              } else if (txt == "Large Text") {
                                controller.selectedTypeKey.value = "longtext";
                              } else if (txt == "Dropdown Options") {
                                controller.selectedTypeKey.value = "dropdown";
                              } else if (txt == "Declined") {
                                controller.selectedTypeKey.value = "decline";
                              } else {
                                controller.selectedTypeKey.value = "range";
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 0.0),
                          child: Text('- ${AppLocalizations.of(context)!.showInClientOrderForm}: *', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                        ),
                        DropdownButton(
                            value: controller.selectedClientFormValue.value,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'Montserrat'),
                            iconEnabledColor: Colors.white,
                            dropdownColor: ConstantColor.primary,
                            isExpanded: true,
                            items: controller.arrRequiredDropDownFields,
                            onChanged: (txt) {
                              if (txt == null) return;
                              controller.selectedClientFormValue.value = txt;
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 0.0),
                          child: Text('- ${AppLocalizations.of(context)!.required}: *', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                        ),
                        DropdownButton(
                            value: controller.selectedRequiredValue.value,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'Montserrat'),
                            iconEnabledColor: Colors.white,
                            dropdownColor: ConstantColor.primary,
                            isExpanded: true,
                            items: controller.arrRequiredDropDownFields,
                            onChanged: (txt) {
                              if (txt == null) return;
                              controller.selectedRequiredValue.value = txt;
                            }),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GestureDetector(
                            onTap: () {

                              if (nameController.text.trim().isEmpty) {
                                ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterFieldName);
                              } else {

                                if (isGeneral) {
                                  Map<String, dynamic> bodyParams = {
                                    "name": nameController.text.trim(),
                                    "type": controller.selectedTypeKey.value,
                                    "isShow": controller.selectedClientFormValue.value == "Yes" ? true : false,
                                    "required": controller.selectedRequiredValue.value == "Yes" ? true : false,
                                  };
                                  print("Add/Edit general order field params ${bodyParams}");

                                  if (isEdit) {
                                    controller.editGeneralOrderField(bodyParams, "${generalField.id ?? ''}").then((response) {
                                      if (response['success'].toString() == "true") {
                                        Get.back(result: "added");
                                        ShowToast.showToast(response['message'].toString());
                                      } else {
                                        ShowToast.showToast(response['message'].toString());
                                      }
                                    });
                                  } else {
                                    controller.addGeneralOrderField(bodyParams).then((response) {
                                      if (response['success'].toString() == "true") {
                                        Get.back(result: "added");
                                        ShowToast.showToast(response['message'].toString());
                                      } else {
                                        ShowToast.showToast(response['message'].toString());
                                      }
                                    });
                                  }
                                } else {
                                  Map<String, dynamic> bodyParams = {
                                    "name": nameController.text.trim(),
                                    "type": controller.selectedTypeKey.value,
                                    "isShow": controller.selectedClientFormValue.value == "Yes" ? true : false,
                                    "required": controller.selectedRequiredValue.value == "Yes" ? true : false,
                                    "categoryId": categoryId
                                  };
                                  print("Add category order field params ${bodyParams}");

                                  controller.addCategoryOrderField(bodyParams).then((response) {
                                    if (response['success'].toString() == "true") {
                                      Get.back(result: "added");
                                      ShowToast.showToast(response['message'].toString());
                                    } else {
                                      ShowToast.showToast(response['message'].toString());
                                    }
                                  });
                                }
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