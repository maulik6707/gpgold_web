import 'package:flutter/material.dart';
import 'package:gdgold/controller/karigar/karigar_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/karigar/add_karigar_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class KarigarScreen extends StatelessWidget {
  KarigarScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<KarigarController>(
      init: KarigarController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.karigar, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.search, color: Colors.white, size: 18,),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context)!.search,
                                    hintStyle: const TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400)
                                ),
                                controller: searchController,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(height: 0.5, color: Colors.white,),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.arrKarigar.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.to(CreateOrderStepTwoScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ConstantColor.gradientTopColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.white, width: 0.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.8),
                                          blurRadius: 3.0,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text('${AppLocalizations.of(context)!.karigarName}: ${controller.arrKarigar[index].name ?? ''}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.start,)),
                                            InkWell(
                                                onTap: () {
                                                  controller.deleteKarigar(controller.arrKarigar[index].id ?? 0);
                                                },
                                                child: Container(padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),child: const Icon(Icons.delete_outline, color: Colors.white, size: 16,),))
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                          child: Text('${AppLocalizations.of(context)!.mobileNo}.: ${controller.arrKarigar[index].phoneNumber ?? ''}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                        ),
                                        Text('${AppLocalizations.of(context)!.city}: ${controller.arrKarigar[index].city ?? ''}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          child: Container(height: 0.5, color: Colors.white,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 25.0),
                                                child: InkWell(onTap: () async {
                                                  final String url = "tel:${controller.arrKarigar[index].phoneNumber}";

                                                  if (await canLaunchUrl(Uri.parse(url))) {
                                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                                  } else {
                                                    ShowToast.showToast("WhatsApp not installed or cannot launch URL");
                                                  }
                                                },child: const Icon(Icons.phone, color: Colors.white,)),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 25.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    final String url = "https://wa.me/${controller.arrKarigar[index].phoneNumber}?text=${Uri.encodeFull("")}";

                                                    if (await canLaunchUrl(Uri.parse(url))) {
                                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                                    } else {
                                                    ShowToast.showToast("WhatsApp not installed or cannot launch URL");
                                                    }
                                                  },
                                                  child: Image.asset("assets/icon/ic_whatsapp.jpg", fit: BoxFit.cover,
                                                    width: 25,
                                                    height: 25,),
                                                ),
                                              ),
                                            ],
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
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(AddKarigarScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                            if (value == "added") {

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
                            child: Center(child: Text(AppLocalizations.of(context)!.addKarigar, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
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