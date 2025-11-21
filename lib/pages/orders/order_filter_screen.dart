import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/orders/order_filter_controller.dart';
import 'package:gdgold/pages/karigar/select_karigar_screen.dart';
import 'package:gdgold/pages/orders/create_order_step_first_screen.dart';
import 'package:gdgold/pages/orders/create_order_step_two_screen.dart';
import 'package:gdgold/pages/orders/select_client_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class OrderFilterScreen extends StatelessWidget {
  OrderFilterScreen({Key? key}) : super(key: key);

  final fromOrderDateController = TextEditingController();
  final toOrderDateController = TextEditingController();
  final fromDeliveryDateController = TextEditingController();
  final toDeliveryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<OrderFilterController>(
      init: OrderFilterController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.filter, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(AppLocalizations.of(context)!.clearAll, style: const TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.center)),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      Visibility(
                        visible: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text('- ${AppLocalizations.of(context)!.orderStatus}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: DropdownButton(
                            value: controller.selectedStatusValue.value,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'Montserrat'),
                            iconEnabledColor: Colors.white,
                            dropdownColor: ConstantColor.primary,
                            isExpanded: true,
                            items: controller.arrDropDownFields,
                            onChanged: (txt) {
                              if (txt == null) return;
                              controller.selectedStatusValue.value = txt;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Text('- ${AppLocalizations.of(context)!.selectCategory}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                      ),
                      GestureDetector(
                        onTap: () {
                          var argument = {
                            'isFromFilter': true,
                          };
                          Get.to(CreateOrderStepFirstScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                            if (value != null) {
                              controller.selectedCategoryId = value["id"];
                              controller.selectedCategoryName.value = value["name"];
                            }
                          });
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(child: Text(controller.selectedCategoryName.value == '' ? 'Select' : controller.selectedCategoryName.value, style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,)),
                              const Icon(Icons.arrow_drop_down, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.userMap['role'] != 'client',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text(
                            '- ${AppLocalizations.of(context)!.selectClient}: *',
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.userMap['role'] != 'client',
                        child: GestureDetector(
                          onTap: () {
                            Get.to(SelectClientScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((onValue) {
                              if (onValue != null) {
                                controller.selectedClientId = onValue["id"];
                                controller.selectedClientName.value = onValue["name"];
                              }
                            });
                          },
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      (controller.selectedClientName.isEmpty) ? 'Select' : controller.selectedClientName.value,
                                      style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                    )),
                                const Icon(Icons.arrow_drop_down, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.userMap['role'] != 'client',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text(
                            '- ${AppLocalizations.of(context)!.selectKarigar}: *',
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.userMap['role'] != 'client',
                        child: GestureDetector(
                          onTap: () {
                            var argument = {
                              'isFromFilter': true,
                            };
                            Get.to(SelectKarigarScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((onValue) {
                              if (onValue != null) {
                                controller.selectedKarigarId = onValue["id"];
                                controller.selectedKarigarName.value = onValue["name"];
                              }
                            });
                          },
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      (controller.selectedKarigarName.isEmpty) ? 'Select' : controller.selectedKarigarName.value,
                                      style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                    )),
                                const Icon(Icons.arrow_drop_down, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Text('- ${AppLocalizations.of(context)!.orderDate}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "From",
                                    hintStyle: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  controller: fromOrderDateController,
                                  onTap: () {
                                    showDateDialog(CupertinoDatePicker(
                                      initialDateTime: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      showDayOfWeek: false,
                                      onDateTimeChanged: (DateTime newDate) {
                                        fromOrderDateController.text = "${newDate.year}-${newDate.month}-${newDate.day}";
                                        // controller.deliveryDate.value = newDate;
                                      },
                                    ), context);
                                  },
                                ),
                                Container(height: 0.5, color: Colors.white,),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "To",
                                    hintStyle: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: toOrderDateController,
                                  onTap: () {
                                    showDateDialog(CupertinoDatePicker(
                                      initialDateTime: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      showDayOfWeek: false,
                                      onDateTimeChanged: (DateTime newDate) {
                                        toOrderDateController.text = "${newDate.year}-${newDate.month}-${newDate.day}";
                                        // controller.deliveryDate.value = newDate;
                                      },
                                    ), context);
                                  },
                                ),
                                Container(height: 0.5, color: Colors.white,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Text('- ${AppLocalizations.of(context)!.deliveryDate}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "From",
                                    hintStyle: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: fromDeliveryDateController,
                                  onTap: () {
                                    showDateDialog(CupertinoDatePicker(
                                      initialDateTime: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      showDayOfWeek: false,
                                      onDateTimeChanged: (DateTime newDate) {
                                        fromDeliveryDateController.text = "${newDate.year}-${newDate.month}-${newDate.day}";
                                        // controller.deliveryDate.value = newDate;
                                      },
                                    ), context);
                                  },
                                ),
                                Container(height: 0.5, color: Colors.white,),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "To",
                                    hintStyle: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: toDeliveryDateController,
                                  onTap: () {
                                    showDateDialog(CupertinoDatePicker(
                                      initialDateTime: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      showDayOfWeek: false,
                                      onDateTimeChanged: (DateTime newDate) {
                                        toDeliveryDateController.text = "${newDate.year}-${newDate.month}-${newDate.day}";
                                        // controller.deliveryDate.value = newDate;
                                      },
                                    ), context);
                                  },
                                ),
                                Container(height: 0.5, color: Colors.white,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Text('- ${AppLocalizations.of(context)!.priority}', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                      ),
                      SizedBox(
                        height: 50,
                        child: Obx(
                              () => ListView.builder(
                            itemCount: controller.arrPriority.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Obx(
                                      () => Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.selectedPriority.value = controller.arrPriority[index];
                                      },
                                      child: Container(
                                          height: 50,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              border: Border.all(color: Colors.white, width: 1),
                                              color: controller.selectedPriority.value == controller.arrPriority[index] ? ConstantColor.white : ConstantColor.black
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                          child: Center(child: Text(controller.arrPriority[index], style: TextStyle(color: controller.selectedPriority.value == controller.arrPriority[index] ? ConstantColor.black : ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
                                      ),
                                    ),
                                  ));
                            },
                          ),),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            var filteredUrl = '';
                            if (controller.selectedCategoryName.value.isNotEmpty) {
                              filteredUrl = "$filteredUrl&categoryId=${controller.selectedCategoryId}";
                            }
                            if (controller.selectedClientName.value.isNotEmpty) {
                              filteredUrl = "$filteredUrl&clientId=${controller.selectedClientId}";
                            }
                            if (controller.selectedKarigarName.value.isNotEmpty) {
                              filteredUrl = "$filteredUrl&karigarId=${controller.selectedKarigarId}";
                            }
                            if (controller.selectedPriority.value.isNotEmpty) {
                              filteredUrl = "$filteredUrl&priority=${controller.selectedPriority.value.split(" ").first.toLowerCase()}";
                            }
                            if (fromOrderDateController.text.isNotEmpty) {
                              filteredUrl = "$filteredUrl&dateFrom=${fromOrderDateController.text}";
                            }
                            if (toOrderDateController.text.isNotEmpty) {
                              filteredUrl = "$filteredUrl&dateTo=${toOrderDateController.text}";
                            }
                            if (fromDeliveryDateController.text.isNotEmpty) {
                              filteredUrl = "$filteredUrl&deliverDateFrom=${fromDeliveryDateController.text}";
                            }
                            if (toDeliveryDateController.text.isNotEmpty) {
                              filteredUrl = "$filteredUrl&deliverDateTo=${toDeliveryDateController.text}";
                            }
                            Get.back(result: filteredUrl);
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
                              child: Center(child: Text(AppLocalizations.of(context)!.showResults, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
                          ),
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

  void showDateDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
