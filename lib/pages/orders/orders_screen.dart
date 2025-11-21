import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/orders/orders_controller.dart';
import 'package:gdgold/pages/orders/order_detail_screen.dart';
import 'package:gdgold/pages/orders/order_filter_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:gdgold/themes/responsive.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);

  final ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      if (Get.arguments['selectedStatusValue'] != null) {
        ordersController.selectedStatusValue.value = Get.arguments['selectedStatusValue'];
        if (ordersController.selectedStatusValue.value == "All" || ordersController.selectedStatusValue.value == "") {
          ordersController.arrOrder.clear();
          ordersController.getOrders('&page=${ordersController.currentPage}&limit=20');
        } else {
          ordersController.arrOrder.clear();
          ordersController.getOrders(
              '&page=${ordersController.currentPage}&limit=20&status=${ordersController.selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}');
        }
      } else {
        ordersController.arrOrder.clear();
        ordersController.getOrders('&page=${ordersController.currentPage}&limit=20');
      }
    } else {
      ordersController.arrOrder.clear();
      ordersController.getOrders('&page=${ordersController.currentPage}&limit=20');
    }

    return GetX<OrdersController>(
      init: OrdersController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            controller.currentPage = 1;
            Get.delete<OrdersController>();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.order,
                  style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              centerTitle: true,
              backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  controller.isLoading.value = false;
                  controller.currentPage = 1;
                  Get.delete<OrdersController>();
                  Get.back();
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    )),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    ordersController.arrOrder.clear();
                    ordersController.currentPage = 1;
                    ordersController.filterUrl = '';
                    if (ordersController.selectedStatusValue.value == "All" || ordersController.selectedStatusValue.value == "") {
                      controller.getOrders("&page=${ordersController.currentPage}&limit=20");
                    } else {
                      controller.getOrders(
                          "&page=${ordersController.currentPage}&limit=20&status=${ordersController.selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}");
                    }
                    controller.getOrders(
                        "&page=${ordersController.currentPage}&limit=20&status=${ordersController.selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}");
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.filter_alt_off,
                        color: Colors.white,
                      )),
                ),
                InkWell(
                  onTap: () {
                    Get.to(OrderFilterScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((value) {
                      if (value != null) {
                        ordersController.arrOrder.clear();
                        ordersController.currentPage = 1;
                        if (ordersController.selectedStatusValue.value == "All" || ordersController.selectedStatusValue.value == "") {
                          ordersController.filterUrl = value;
                          controller.getOrders(value + "&page=${ordersController.currentPage}&limit=20");
                        } else {
                          controller.getOrders(value +
                              "&page=${ordersController.currentPage}&limit=20&status=${ordersController.selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}");
                        }
                      }
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                      )),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          color: ConstantColor.gradientTopColor,
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.sortBy,
                                  style: const TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    ordersController.filterUrl = '';
                                    controller.getOrders('&sortField=deliveryDate&sortOrder=desc}');
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(AppLocalizations.of(context)!.deliveryDate,
                                              style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.start)),
                                      const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ordersController.filterUrl = '';
                                  controller.getOrders('&sortField=orderDate&sortOrder=desc}');
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(AppLocalizations.of(context)!.orderDate,
                                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.start)),
                                    const Icon(
                                      Icons.circle_outlined,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    ordersController.filterUrl = '';
                                    controller.getOrders('&sortField=quantity&sortOrder=asc}');
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(AppLocalizations.of(context)!.quantity,
                                              style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.start)),
                                      const Icon(
                                        Icons.circle_outlined,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      height: 40,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: Colors.white, width: 1),
                                          color: Colors.white),
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                      child: Center(
                                          child: Text(
                                        AppLocalizations.of(context)!.showResults,
                                        style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.start,
                                      ))),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.sort_outlined,
                        color: Colors.white,
                      )),
                ),
              ],
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
                      DropdownButton(
                          value: controller.selectedStatusValue.value,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'Montserrat'),
                          iconEnabledColor: Colors.white,
                          dropdownColor: ConstantColor.primary,
                          isExpanded: true,
                          items: controller.arrDropDownFields,
                          onChanged: (txt) {
                            if (txt == null) return;
                            controller.selectedStatusValue.value = txt;
                            ordersController.filterUrl = '';
                            if (controller.selectedStatusValue.value == "All") {
                              ordersController.currentPage = 1;
                              controller.arrOrder.clear();
                              controller.getOrders('&page=${ordersController.currentPage}&limit=20');
                            } else {
                              ordersController.currentPage = 1;
                              controller.arrOrder.clear();
                              controller.getOrders(
                                  '&status=${controller.selectedStatusValue.value.replaceAll(" ", "_").toLowerCase()}&page=${ordersController.currentPage}&limit=20');
                            }
                          }),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            itemCount: controller.arrOrder.length,
                            scrollDirection: Axis.vertical,
                            controller: controller.scrollController,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  var argument = {'orderDetail': controller.arrOrder[index]};
                                  Get.to(() => OrderDetailScreen(),
                                          arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!
                                      .then((value) {
                                    if (value == "added") {
                                      // controller.arrOrder.clear();
                                      // controller.getOrders("&page=1&limit=10");
                                    }
                                  });
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
                                              imageUrl: controller.arrOrder[index].img1 ?? '',
                                              placeholder: (context, url) {
                                                return const Loader();
                                              },
                                              errorWidget: (context, url, error) => Image.asset("assets/bangles.jpg", fit: BoxFit.fill)),
                                        ),
                                        SizedBox(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                                      stops: const [0.0, 1]),
                                                ),
                                              ),
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
                                        SizedBox(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${AppLocalizations.of(context)!.orderNo}: ${controller.arrOrder[index].order_no ?? ''}',
                                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                                Text('${AppLocalizations.of(context)!.name}: ${controller.arrOrder[index].client_name ?? ''}',
                                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    Text('${AppLocalizations.of(context)!.orderDate}: ${controller.arrOrder[index].orderDate ?? ''}',
                                                        style:
                                                            const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                                    const Spacer(),
                                                    Text(
                                                        '${AppLocalizations.of(context)!.deliveryDate}: ${controller.arrOrder[index].deliveryDate ?? ''}',
                                                        style:
                                                            const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                                  ],
                                                ),
                                                Text('${AppLocalizations.of(context)!.remarks}: ${controller.arrOrder[index].remarks ?? 'N/A'}',
                                                    style: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                              ],
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
