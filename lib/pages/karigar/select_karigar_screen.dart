import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/karigar/select_karigar_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class SelectKarigarScreen extends StatelessWidget {
  SelectKarigarScreen({Key? key}) : super(key: key);

  final selectKarigarController = Get.put(SelectKarigarController());

  @override
  Widget build(BuildContext context) {

    if (Get.arguments != null) {
      if (Get.arguments['orderId']!= null) {
        selectKarigarController.orderId = Get.arguments['orderId'];
      }

      if (Get.arguments['isFromFilter'] != null) {
        if (Get.arguments['isFromFilter']) {
          selectKarigarController.isFromFilter = true;
        }
      }
    }

    return GetX<SelectKarigarController>(
      init: SelectKarigarController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.selectKarigar, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  Get.back(result: "added");
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
                            itemCount: controller.arrKarigar.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {

                                  if (controller.isFromFilter) {
                                    Get.back(result: {"id": "${controller.arrKarigar[index].id}", "name": "${controller.arrKarigar[index].name}"});
                                  } else {
                                    Map<String, dynamic> bodyParams = {
                                      "karigarId": controller.arrKarigar[index].id ?? 0
                                    };

                                    print("Assign Karigar params ${bodyParams}");

                                    controller.assignKarigar(bodyParams).then((response) {
                                      if (response['success'] == true) {
                                        Get.back(result: "added");
                                        ShowToast.showToast(response['message'].toString());
                                      } else {
                                        ShowToast.showToast(response['message'].toString());
                                      }
                                    });
                                  }
                                  // Get.back(result: {"id": "${controller.arrKarigar[index].id}", "name": "${controller.arrKarigar[index].name}"});
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 10.0),
                                            child: Text(controller.arrKarigar[index].name ?? '', style: TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
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
