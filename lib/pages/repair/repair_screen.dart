import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/repair/repair_controller.dart';
import '../../l10n/app_localizations.dart';
import 'package:gdgold/pages/repair/create_repair_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:gdgold/themes/responsive.dart';
import 'package:get/get.dart';

class RepairScreen extends StatelessWidget {
  RepairScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<RepairController>(
      init: RepairController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.repair, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
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
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 80),
                          child: ListView.builder(
                            itemCount: controller.arrRepair.length,
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
                                          child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            controller.deleteRepair(controller.arrRepair[index].id ?? '0');
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                  // Get.to(CreateOrderStepTwoScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: Responsive.width(90, context),
                                          decoration: const BoxDecoration(
                                            color: Colors.white10,
                                          ),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: controller.arrRepair[index].img1 ?? '',
                                              placeholder: (context, url) {
                                                return const Loader();
                                              },
                                              errorWidget: (context, url, error) => Image.asset("assets/bangles.jpg", fit: BoxFit.fill)),
                                        ),
                                        SizedBox(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              const Spacer(),
                                              Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                                      stops: const [0.0, 1]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: SizedBox(
                                            height: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Spacer(),
                                                  // Text('${AppLocalizations.of(context)!.orderNo}: ${controller.arrRepair[index].orderId ?? ''}', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                                  Text('${AppLocalizations.of(context)!.note}: ${controller.arrRepair[index].remarks ?? ''}', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(CreateRepairScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                            if (value == "added") {
                              controller.getRepair();
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
                            child: Center(child: Text(AppLocalizations.of(context)!.addRepair, style: TextStyle(color: ConstantColor.gradientTopColor, fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
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
