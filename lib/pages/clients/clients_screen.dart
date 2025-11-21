import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/clients/clients_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/clients/add_client_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientsScreen extends StatelessWidget {
  ClientsScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<ClientsController>(
      init: ClientsController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            controller.currentPage = 1;
            Get.delete<ClientsController>();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.clients, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              centerTitle: true,
              backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  controller.currentPage = 1;
                  Get.delete<ClientsController>();
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
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 70),
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
                                style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                controller: searchController,
                                onChanged: (value) {
                                  controller.getClients("&search=${searchController.text.trim()}");
                                },
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
                            itemCount: controller.arrClients.length,
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
                                            Expanded(child: Text('${AppLocalizations.of(context)!.clientName}: ${controller.arrClients[index].full_name}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.start,)),
                                            InkWell(
                                                onTap: () {
                                                  controller.deleteClient(controller.arrClients[index].id ?? 0);
                                                },
                                                child: Container(padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),child: const Icon(Icons.delete_outline, color: Colors.white, size: 16,),))
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                          child: Text('${AppLocalizations.of(context)!.mobileNo}.: ${controller.arrClients[index].phoneNumber}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text('${AppLocalizations.of(context)!.companyName}.: ${controller.arrClients[index].company_name}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                        ),
                                        Text('${AppLocalizations.of(context)!.email}: ${controller.arrClients[index].email}', style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
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
                                                padding: EdgeInsets.only(left: 25.0),
                                                child: InkWell(onTap: () async {
                                                  var url = "tel:${controller.arrClients[index].phoneNumber}";
                                                  if (await canLaunch(url)) {
                                                  await launch(url);
                                                  } else {
                                                  ShowToast.showToast('Could not call client');
                                                  }
                                                },child: Icon(Icons.phone, color: Colors.white,)),
                                              ),
                                              const Spacer(),
                                              InkWell(onTap: () async {
                                                final String url = 'mailto:${controller.arrClients[index].email}?subject=%20&body=%20';

                                                if (await canLaunchUrl(Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication); // Key for Gmail
                                                } else {
                                                ShowToast.showToast('Could not launch email client');
                                                }
                                              },child: const Icon(Icons.email_outlined, color: Colors.white,)),
                                              const Spacer(),
                                              InkWell(onTap: () async {
                                                final String url = "https://wa.me/${controller.arrClients[index].phoneNumber}?text=${Uri.encodeFull("")}";

                                                if (await canLaunchUrl(Uri.parse(url))) {
                                                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                                } else {
                                                  ShowToast.showToast("WhatsApp not installed or cannot launch URL");
                                                }
                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 0.0),
                                                  child: Image.asset("assets/icon/ic_whatsapp.jpg", fit: BoxFit.cover,
                                                    width: 22,
                                                    height: 22,),
                                                ),
                                              ),
                                              const Spacer(),
                                              CupertinoSwitch(
                                                value: (controller.arrClients[index].isActive ?? 'inactive') == "active",      // Boolean value indicating the current state of the switch
                                                onChanged: (bool value) {

                                                  Map<String, dynamic> bodyParams = {
                                                    'id': controller.arrClients[index].id ?? 0,
                                                    'isActive': (controller.arrClients[index].isActive ?? 'inactive') == "active" ? "inactive" : "active",
                                                  };
                                                  print("Deactivate client params ${bodyParams}");

                                                  controller.deactivateClient(bodyParams).then((response) {

                                                    if (response['success'].toString() == "true") {
                                                      controller.getClients('&page=1&limit=20');
                                                      ShowToast.showToast(response['message'].toString());

                                                    } else {
                                                      ShowToast.showToast(response['message'].toString());
                                                    }
                                                  });
                                                },
                                                thumbColor: ConstantColor.black,
                                                inactiveTrackColor: ConstantColor.white,
                                                inactiveThumbColor: ConstantColor.black,
                                              )
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
                          Get.to(AddClientScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((onValue) {
                            if (onValue == "added") {
                              controller.getClients('&page=1&limit=20');
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
                            child: Center(child: Text(AppLocalizations.of(context)!.addClient, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
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