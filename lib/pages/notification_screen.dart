import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/notification_controller.dart';
import 'package:gdgold/model/order_model.dart';
import 'package:gdgold/pages/category/add_category_screen.dart';
import 'package:gdgold/pages/category/category_fields_screen.dart';
import 'package:gdgold/pages/orders/order_detail_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(

              title: const Text('Notification', style: TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
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
                            itemCount: controller.arrNotification.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) => CupertinoActionSheet(
                                      title: const Text('Select Options', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Montserrat',)),
                                      cancelButton: CupertinoActionSheetAction(
                                        child: const Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                        onPressed: () {
                                          Navigator.pop(context, 'One');
                                        },
                                      ),
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          child: const Text('Read', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("notification")
                                                .doc("${controller.userMap['id']}")
                                                .collection("notifications")
                                                .doc(controller.arrNotification[index].notificationId)
                                                .set({
                                              'notificationId': controller.arrNotification[index].notificationId,
                                              'orderID': controller.arrNotification[index].orderID,
                                              'message': controller.arrNotification[index].message,
                                              'isRead': true,
                                            });
                                            controller.getNotificationData();
                                            Navigator.pop(context, 'Read');
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: const Text('View', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            var argument = {
                                              'orderId': controller.arrNotification[index].orderID,
                                              'isFromNotification': true
                                            };
                                            Get.to(OrderDetailScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: const Text('Delete', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Montserrat',)),
                                          onPressed: () {
                                            Navigator.pop(context, 'Delete');
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                  // Get.to(CreateOrderStepTwoScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                },
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible: !(controller.arrNotification[index].isRead ?? false),
                                      child: Icon(Icons.circle, color: index % 2 == 0 ? Colors.white : ConstantColor.gradientTopColor, size: 10,),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 10.0, right: 5),
                                                    child: Text(controller.arrNotification[index].message ?? '', style: const TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                                                  ),
                                                ),
                                                Container(),
                                              ],
                                            ),
                                            Container(color: Colors.white, height: 0.5,)
                                          ],
                                        ),
                                      ),
                                    ),
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
