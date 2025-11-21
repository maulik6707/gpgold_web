import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/home_controller.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/pages/about_us_screen.dart';
import 'package:gdgold/pages/auth/change_password_screen.dart';
import 'package:gdgold/pages/category/general_fields_screen.dart';
import 'package:gdgold/pages/karigar/karigar_screen.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/pages/notification_screen.dart';
import 'package:gdgold/pages/orders/buffer_days_screen.dart';
import 'package:gdgold/pages/orders/create_order_step_first_screen.dart';
import 'package:gdgold/pages/orders/orders_screen.dart';
import 'package:gdgold/pages/repair/repair_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import '../l10n/app_localizations.dart';
import 'category/category_screen.dart';
import 'clients/clients_screen.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Upgrader upgrader = Upgrader(
    debugLogging: true
  );

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return UpgradeAlert(
          upgrader: upgrader,showIgnore: false, showLater: false,
          child: WillPopScope(
            onWillPop: () async {
              controller.isLoading.value = false;
              return true;
            },
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(title: const Text('GP Gold', style: TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
                leading: InkWell(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.menu, color: Colors.white,)),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Get.to(NotificationScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                          controller.getLoggedInUser();
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.notifications_none, color: Colors.white,)),
                  ),
                ],
                ),
              drawer: Drawer(
                surfaceTintColor: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: ConstantColor.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 50.0, bottom: 20),
                          child: Center(child: Text('GP Gold', style: TextStyle(color: ConstantColor.white, fontSize: 28, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.home, size: 22, color: Colors.white,),
                              ),
                              Text(AppLocalizations.of(context)!.home, style: const TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(height: 1, color: Colors.white,),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.to(OrdersScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                              controller.getLoggedInUser();
                            });
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.shopping_cart_outlined, size: 22, color: Colors.white,),
                              ),
                              Text(AppLocalizations.of(context)!.order, style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(height: 1, color: Colors.white,),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.to(RepairScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                              controller.getLoggedInUser();
                            });
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.home_repair_service_outlined, size: 22, color: Colors.white,),
                              ),
                              Text(AppLocalizations.of(context)!.repair, style: const TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(height: 1, color: Colors.white,),
                        ),
                        Visibility(
                          visible: controller.userMap['role'] != 'client',
                          child: InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(CategoryScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                                controller.getLoggedInUser();
                              });
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.category, size: 22, color: Colors.white,),
                                ),
                                Text(AppLocalizations.of(context)!.category, style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.userMap['role'] != 'client',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(height: 1, color: Colors.white,),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(ClientsScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                                controller.getLoggedInUser();
                              });
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.person, size: 22, color: Colors.white,),
                                ),
                                Text(AppLocalizations.of(context)!.clients, style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(height: 1, color: Colors.white,),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(KarigarScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                                controller.getLoggedInUser();
                              });
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.personal_injury, size: 22, color: Colors.white,),
                                ),
                                Text(AppLocalizations.of(context)!.karigar, style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(height: 1, color: Colors.white,),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              Get.to(GeneralFieldsScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                                controller.getLoggedInUser();
                              });
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.home_repair_service_outlined, size: 22, color: Colors.white,),
                                ),
                                Text(AppLocalizations.of(context)!.generalFields, style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(height: 1, color: Colors.white,),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              Get.to(BufferDaysScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                                controller.getLoggedInUser();
                              });
                            },
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.date_range, size: 22, color: Colors.white,),
                                ),
                                Text("Buffer Days", style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          // visible: true,
                          visible: controller.userMap['role'] != 'client',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(height: 1, color: Colors.white,),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.to(AboutUsScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                              controller.getLoggedInUser();
                            });
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.info, size: 22, color: Colors.white,),
                              ),
                              Text(AppLocalizations.of(context)!.aboutUs, style: const TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(height: 1, color: Colors.white,),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.to(ChangePasswordScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                              controller.getLoggedInUser();
                            });
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.password_sharp, size: 22, color: Colors.white,),
                              ),
                              Text(AppLocalizations.of(context)!.changePassword, style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(height: 1, color: Colors.white,),
                        ),
                        InkWell(
                          onTap: () {
                            showDeleteAccountDialog(context, controller);
                          },
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.delete_outline, size: 22, color: Colors.white,),
                              ),
                              Text("Delete Account", style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(height: 1, color: Colors.white,),
                        ),
                        GestureDetector(
                          onTap: () {
                            SharPreferences.clearSharPreference();
                            Get.offAll(LoginScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.login_outlined, size: 22, color: Colors.white,),
                                ),
                                Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Center(child: Text('v1.0.1', style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.left)),
                        ),
                      ],
                    ),
                  ),
              ),
              body: Stack(
                children: [
                  Container(
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
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('${AppLocalizations.of(context)!.welcome}, \n${controller.userMap['full_name']}', style: TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.left),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20),
                                child: controller.isLoading.value ? const Loader() : GridView.builder(
                                  itemCount: controller.arrStatus.length,
                                    itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      var argument = {
                                        "selectedStatusValue": (controller.arrStatus[index].status ?? 'All').replaceAll("_", " ").capitalizeFirst ?? ''
                                      };
                                      Get.to(OrdersScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                                        controller.getLoggedInUser();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text((controller.arrStatus[index].status ?? 'All').replaceAll("_", " ").capitalizeFirst ?? '', style: const TextStyle(color: ConstantColor.black, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                                            Text("${controller.arrStatus[index].count ?? 0}", style: const TextStyle(color: ConstantColor.black, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.left),
                                          ],
                                        )
                                      ),
                                    ),
                                  );
                                }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),),
                              ),
                            )
                          ],
                        ),
                        Container(child: controller.isLoading.value ? const Loader() : Container())
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: InkWell(
                      onTap: () async {
                        // controller.sendNotificationOfNewOrder();
                        Get.to(CreateOrderStepFirstScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                          controller.getLoggedInUser();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10.0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 2),
                          gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [ConstantColor.gradientTopColor, ConstantColor.gradientBottomColor],
                              stops: [0.0, 0.80]),
                        ),
                        child: Center(child: Text(AppLocalizations.of(context)!.createOrder, style: TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteAccountDialog(BuildContext context, HomeController controller) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Delete Account", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)),
          content: const Text("Are you sure you want to delete your account?", style: TextStyle(color: ConstantColor.black, fontSize: 14, fontWeight: FontWeight.w400)),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("No", style: TextStyle(color: ConstantColor.black, fontSize: 14, fontWeight: FontWeight.w400)),
              onPressed: () {
                Navigator.of(context).pop(); // dismiss the dialog
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Yes", style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w400)),
              onPressed: () {
                Navigator.of(context).pop(); // dismiss the dialog
                print("Account deleted");
                controller.deleteClient();
                SharPreferences.clearSharPreference();
                Get.offAll(LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }

}
