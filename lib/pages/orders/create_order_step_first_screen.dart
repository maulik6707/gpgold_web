import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/orders/create_order_step_first_controller.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';
import 'create_order_step_two_screen.dart';

class CreateOrderStepFirstScreen extends StatelessWidget {
  CreateOrderStepFirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isFromFilter = false;
    if (Get.arguments != null) {
      if (Get.arguments['isFromFilter']!= null && Get.arguments['isFromFilter']) {
        isFromFilter = true;
      }
    }
    return GetX<CreateOrderStepFirstController>(
      init: CreateOrderStepFirstController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.selectCategory, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
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
                                  if (isFromFilter) {
                                    Get.back(result: {"id": controller.arrCategory[index].id ?? 0, "name": '${controller.arrCategory[index].name ?? 0}'});
                                  } else {
                                    var argument = {
                                      'categoryId': controller.arrCategory[index].id ?? 0,
                                    };
                                    Get.to(CreateOrderStepTwoScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {

                                    });
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 10.0),
                                            child: Text(controller.arrCategory[index].name ?? '', style: const TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                          ),
                                        ),
                                        Container()
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
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: ConstantColor.gradientTopColor,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.25),
                      //         blurRadius: 10.0,
                      //         offset: const Offset(0, 0),
                      //       ),
                      //     ],
                      //   ),
                      //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.max,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Container(
                      //         width: Responsive.width(45, context),
                      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //         decoration: BoxDecoration(
                      //           color: ConstantColor.white,
                      //           borderRadius: const BorderRadius.all(Radius.circular(10)),
                      //           border: Border.all(color: ConstantColor.gradientTopColor, width: 2),
                      //         ),
                      //         child: const Text('Clear', style: TextStyle(color: ConstantColor.gradientTopColor, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
                      //       ),
                      //       Container(
                      //         width: Responsive.width(45, context),
                      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //         decoration: BoxDecoration(
                      //           color: ConstantColor.gradientTopColor,
                      //           borderRadius: const BorderRadius.all(Radius.circular(10)),
                      //           border: Border.all(color: Colors.white, width: 2),
                      //         ),
                      //         child: const Text('Next', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
                      //       ),
                      //     ],
                      //   ),
                      // )
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
