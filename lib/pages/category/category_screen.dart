import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/category/category_controller.dart';
import 'package:gdgold/pages/category/add_category_screen.dart';
import 'package:gdgold/pages/category/category_fields_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CategoryController>(
      init: CategoryController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(

              title: Text(AppLocalizations.of(context)!.category, style: TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
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
                          child: ListView.builder(
                            itemCount: controller.arrCategory.length,
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
                                          child: Text(AppLocalizations.of(context)!.viewCategoryFields, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            var argument = {
                                              'categoryId': controller.arrCategory[index].id ?? 0,
                                            };
                                            Get.to(CategoryFieldsScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            controller.deleteCategory(controller.arrCategory[index].id ?? 0);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                  // Get.to(CreateOrderStepTwoScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 10.0, right: 5),
                                            child: Text(controller.arrCategory[index].name ?? '', style: TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                          ),
                                        ),
                                        Container(),
                                      ],
                                    ),
                                    Container(color: Colors.white, height: 0.5,)
                                  ],
                                ),
                              );
                            },
                          ),
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
                          Get.to(AddCategoryScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                            if (value == "added") {
                              controller.getCategory();
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
                            child: Center(child: Text(AppLocalizations.of(context)!.addCategory, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
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
