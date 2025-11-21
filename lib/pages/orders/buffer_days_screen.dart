import 'package:flutter/material.dart';
import 'package:gdgold/controller/orders/buffer_days_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class BufferDaysScreen extends StatelessWidget {
  BufferDaysScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<BufferDaysController>(
      init: BufferDaysController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.bufferDaysOfDeliveryDate, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                            child: Text('- ${AppLocalizations.of(context)!.bufferDays}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: controller.bufferDaysController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                if (controller.bufferDaysController.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterBufferDays);
                                } else {
                                  Map<String, dynamic> bodyParams = {
                                    "id": 1,
                                    "days": int.parse(controller.bufferDaysController.text)
                                  };
                                  print("Buffer days params ${bodyParams}");

                                  controller.updateBufferDays(bodyParams).then((response) {
                                    if (response['success'].toString() == 'true') {
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