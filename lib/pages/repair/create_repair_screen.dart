import 'package:flutter/material.dart';
import 'package:gdgold/controller/repair/create_repair_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class CreateRepairScreen extends StatelessWidget {
  CreateRepairScreen({Key? key}) : super(key: key);

  final orderNoController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<CreateRepairController>(
      init: CreateRepairController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.addRepair, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                            padding: const EdgeInsets.only(top: 10, bottom: 20.0),
                            child: Row(
                              children: [
                                Text('- ${AppLocalizations.of(context)!.uploadDesign}', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                                Text(' (${AppLocalizations.of(context)!.uptoImages}): *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                              ],
                            ),
                          ),
                          controller.arrImages.isEmpty ? InkWell(
                            onTap: () {
                              controller.openPicker();
                              // controller.pickMultipleImages();
                            },
                            child: Container(
                              height: 70.0,
                              width: 70.0,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(35)),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: const Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 35.0,),
                            ),
                          ) : SizedBox(
                            height: 86.0,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.arrImages.length >= 5 ? controller.arrImages.length : controller.arrImages.length + 1,
                              itemBuilder: (_, index) => index == controller.arrImages.length ? Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    controller.openPicker();
                                    // controller.pickMultipleImages();
                                  },
                                  child: Container(
                                    height: 70.0,
                                    width: 70.0,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 35.0,),
                                  ),
                                ),
                              ) : Container(
                                height: 70.0,
                                width: 70.0,
                                padding: const EdgeInsets.all(4.0),
                                child: Image.file(controller.arrImages[index], fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                              child: Text('- ${AppLocalizations.of(context)!.orderNo}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: TextField(
                              controller: orderNoController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: ""
                              ),
                            ),
                          ),
                          Visibility(
                              visible: false,
                              child: Container(height: 0.5, color: Colors.white,)
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text('- ${AppLocalizations.of(context)!.remarks}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          SizedBox(
                            height: 100,
                            child: TextFormField(
                              maxLines: 3,
                              style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
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

                                // if (orderNoController.text.trim().isEmpty) {
                                //   ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterOrderNo);
                                // } else
                                if (remarksController.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterRemarks);
                                } else {
                                  Map<String, String> bodyParams = {
                                    "remarks": remarksController.text,
                                  };
                                  print("Add Repair params ${bodyParams}");

                                  controller.createRepair(bodyParams).then((response) {
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