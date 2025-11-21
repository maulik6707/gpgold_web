import 'package:flutter/material.dart';
import 'package:gdgold/controller/orders/select_client_controller.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class SelectClientScreen extends StatelessWidget {
  SelectClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SelectClientController>(
      init: SelectClientController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(

              title: Text(AppLocalizations.of(context)!.selectClient, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
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
                            itemCount: controller.arrClients.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.back(result: {"id": "${controller.arrClients[index].id}", "name": "${controller.arrClients[index].full_name}"});
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 10.0),
                                            child: Text(controller.arrClients[index].full_name ?? '', style: TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
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
