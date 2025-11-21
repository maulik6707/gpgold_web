import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/category/dropdown_options_controller.dart';
import 'package:gdgold/pages/category/add_dropdown_option_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class DropdownOptionsScreen extends StatelessWidget {
  DropdownOptionsScreen({Key? key}) : super(key: key);

  final dropdownOptionsController = Get.put(DropdownOptionsController());

  @override
  Widget build(BuildContext context) {

    if (Get.arguments != null) {
      if (Get.arguments['isGeneral']!= null && Get.arguments['isGeneral']) {
        dropdownOptionsController.isGeneral = true;
        dropdownOptionsController.orderFieldId = Get.arguments['orderFieldId'].toString();
        dropdownOptionsController.getDropdowns();
      } else {
        dropdownOptionsController.categoryId = Get.arguments['categoryId'].toString();
        dropdownOptionsController.orderFieldId = Get.arguments['orderFieldId'].toString();
        dropdownOptionsController.getDropdowns();
      }
    }
    return GetX<DropdownOptionsController>(
      init: DropdownOptionsController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(

              title: Text(AppLocalizations.of(context)!.dropdownOptions, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ConstantColor.gradientTopColor, ConstantColor.gradientTopColor],
                    stops: [0.0, 0.80]),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: controller.arrDropdowns.isEmpty ? Center(child: Text(AppLocalizations.of(context)!.noFieldsFound, style: const TextStyle(color: ConstantColor.white, fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.center,))  : ListView.builder(
                            itemCount: controller.arrDropdowns.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) => CupertinoActionSheet(
                                      title: Text(AppLocalizations.of(context)!.selectOptions, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Montserrat',)),
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                        onPressed: () {
                                          Navigator.pop(context, 'One');
                                        },
                                      ),
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          child: Text(AppLocalizations.of(context)!.edit, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            Navigator.pop(context, 'One');
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            Navigator.pop(context, 'Two');
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 10.0, right: 5),
                                            child: Text(controller.arrDropdowns[index].dropDownOptionName ?? '', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(color: Colors.white, height: 0.5,)
                                  ],
                                ),
                              );
                            },
                          )
                          ,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          var argument = {};
                          if (controller.isGeneral) {
                            argument = {
                              'isGeneral': controller.isGeneral,
                              'orderFieldId': controller.orderFieldId,
                            };
                          } else {
                            argument = {
                              'categoryId': controller.categoryId,
                              'orderFieldId': controller.orderFieldId,
                            };
                          }
                          Get.to(AddDropdownOptionScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((onValue) {
                            if (onValue == "added") {
                              controller.getDropdowns();
                            }
                          });
                        },
                        child: Container(
                            height: 50,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 3.0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            child: Center(child: Text(AppLocalizations.of(context)!.addOption, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
                        ),
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
