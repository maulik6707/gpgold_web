import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/orders/create_order_step_two_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/orders/select_client_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class CreateOrderStepTwoScreen extends StatelessWidget {
  CreateOrderStepTwoScreen({Key? key}) : super(key: key);

  final createOrderStepTwoController = Get.put(CreateOrderStepTwoController());

  final referenceController = TextEditingController();
  final quantityController = TextEditingController();
  final weightFromController = TextEditingController();
  final weightToController = TextEditingController();
  final deliveryDueDateController = TextEditingController();
  final widthController = TextEditingController();
  final diamondWeightFromController = TextEditingController();
  final diamondWeightToController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("controller.isEditImage.value ${createOrderStepTwoController.isEditImage.value}");

    if (Get.arguments != null) {
      createOrderStepTwoController.categoryId = Get.arguments['categoryId'].toString();

      if (Get.arguments['isEdit'] != null && Get.arguments['isEdit']) {
        createOrderStepTwoController.isEdit = true;
        createOrderStepTwoController.orderDetail = Get.arguments['orderDetail'];

        deliveryDueDateController.text = createOrderStepTwoController.orderDetail.deliveryDate ?? '';
        remarksController.text = createOrderStepTwoController.orderDetail.remarks ?? '';
        createOrderStepTwoController.selectedPriority.value = (createOrderStepTwoController.orderDetail.priority ?? '') == "customer" ? "CUSTOMER ORDER" : "STOCK ORDER";
        if (createOrderStepTwoController.orderDetail.img1 != null && createOrderStepTwoController.orderDetail.img1.toString() != "null") {
          createOrderStepTwoController.arrEditImages.add(createOrderStepTwoController.orderDetail.img1 ?? '');
        }

        if (createOrderStepTwoController.orderDetail.img2 != null && createOrderStepTwoController.orderDetail.img2.toString() != "null") {
          createOrderStepTwoController.arrEditImages.add(createOrderStepTwoController.orderDetail.img2 ?? '');
        }

        if (createOrderStepTwoController.orderDetail.img3 != null && createOrderStepTwoController.orderDetail.img3.toString() != "null") {
          createOrderStepTwoController.arrEditImages.add(createOrderStepTwoController.orderDetail.img3 ?? '');
        }

        if (createOrderStepTwoController.orderDetail.img4 != null && createOrderStepTwoController.orderDetail.img4.toString() != "null") {
          createOrderStepTwoController.arrEditImages.add(createOrderStepTwoController.orderDetail.img4 ?? '');
        }

        if (createOrderStepTwoController.orderDetail.img5 != null && createOrderStepTwoController.orderDetail.img5.toString() != "null") {
          createOrderStepTwoController.arrEditImages.add(createOrderStepTwoController.orderDetail.img5 ?? '');
        }
      }

      createOrderStepTwoController.getGeneralOrderField();
    }
    return GetX<CreateOrderStepTwoController>(
      init: CreateOrderStepTwoController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            controller.arrImages.clear();
            controller.arrEditImages.clear();
            controller.fields.clear();
            controller.generalFields.clear();
            controller.clientDetail.clear();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title:
                  Text(AppLocalizations.of(context)!.enterSpecifications, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              centerTitle: true,
              backgroundColor: ConstantColor.gradientTopColor,
              leading: InkWell(
                onTap: () {
                  controller.isLoading.value = false;
                  controller.arrImages.clear();
                  controller.arrEditImages.clear();
                  controller.fields.clear();
                  controller.generalFields.clear();
                  controller.clientDetail.clear();
                  Get.back();
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    )),
              ),
            ),
            body: controller.isLoading.value
                ? const Loader()
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [ConstantColor.gradientTopColor, ConstantColor.gradientTopColor], stops: [0.0, 0.80]),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '- ${AppLocalizations.of(context)!.uploadDesign}',
                                        style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        ' (${AppLocalizations.of(context)!.uptoImages}): *',
                                        style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: (controller.isEdit == false),
                                  child: (controller.arrImages.isEmpty)
                                      ? InkWell(
                                          onTap: () {
                                            _showImagePickerOptions(context, controller);
                                            // controller.openPicker();
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
                                            child: const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.white,
                                              size: 35.0,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 86.0,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(8),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.arrImages.length >= 5 ? controller.arrImages.length : controller.arrImages.length + 1,
                                            itemBuilder: (_, index) => index == controller.arrImages.length
                                                ? Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showImagePickerOptions(context, controller);
                                                        // controller.openPicker();
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
                                                        child: const Icon(
                                                          Icons.add_a_photo_outlined,
                                                          color: Colors.white,
                                                          size: 35.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 70.0,
                                                    width: 70.0,
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Image.file(controller.arrImages[index], fit: BoxFit.fill),
                                                  ),
                                          ),
                                        ),
                                ),
                                Visibility(
                                  visible: (controller.isEditImage.value == false && controller.isEdit == true),
                                  child: (controller.arrEditImages.isEmpty)
                                      ? InkWell(
                                          onTap: () {
                                            _showImagePickerOptions(context, controller);
                                            // controller.openPicker();
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
                                            child: const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.white,
                                              size: 35.0,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 86.0,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(8),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.arrEditImages.length >= 5 ? controller.arrEditImages.length : controller.arrEditImages.length + 1,
                                            itemBuilder: (_, index) => index == controller.arrEditImages.length
                                                ? Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showImagePickerOptions(context, controller);
                                                        // controller.openPicker();
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
                                                        child: const Icon(
                                                          Icons.add_a_photo_outlined,
                                                          color: Colors.white,
                                                          size: 35.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 70.0,
                                                    width: 70.0,
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: CachedNetworkImage(
                                                        fit: BoxFit.fill,
                                                        imageUrl: controller.arrEditImages[index],
                                                        placeholder: (context, url) {
                                                          return const Loader();
                                                        },
                                                        errorWidget: (context, url, error) => Image.asset("assets/bangles.jpg", fit: BoxFit.fill)),
                                                  ),
                                          ),
                                        ),
                                ),
                                Visibility(
                                  visible: (controller.isEditImage.value) && controller.isEdit == true,
                                  child: (controller.arrImages.isEmpty)
                                      ? InkWell(
                                          onTap: () {
                                            _showImagePickerOptions(context, controller);
                                            // controller.openPicker();
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
                                            child: const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.white,
                                              size: 35.0,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 86.0,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(8),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.arrImages.length >= 5 ? controller.arrImages.length : controller.arrImages.length + 1,
                                            itemBuilder: (_, index) => index == controller.arrImages.length
                                                ? Padding(
                                                    padding: const EdgeInsets.only(left: 10.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showImagePickerOptions(context, controller);
                                                        // controller.openPicker();
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
                                                        child: const Icon(
                                                          Icons.add_a_photo_outlined,
                                                          color: Colors.white,
                                                          size: 35.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 70.0,
                                                    width: 70.0,
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Image.file(controller.arrImages[index], fit: BoxFit.fill),
                                                  ),
                                          ),
                                        ),
                                ),
                                Visibility(
                                  visible: controller.userMap['role'] != 'client',
                                  // visible: true,
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
                                  // visible: true,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(SelectClientScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((onValue) {
                                        if (onValue != null) {
                                          controller.clientDetail["id"] = onValue["id"];
                                          controller.clientDetail["name"] = onValue["name"];
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
                                            (controller.clientDetail["name"] == null || controller.clientDetail["name"].isEmpty) ? 'Select' : controller.clientDetail["name"],
                                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.start,
                                          )),
                                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Visibility(
                                  visible: false,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20.0, bottom: 0.0),
                                    child: Text(
                                      '- Reference No: ',
                                      style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: TextField(
                                    controller: referenceController,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                                  ),
                                ),
                                // Visibility(
                                //   visible: controller.userMap['role'] != 'client',
                                //   child: Container(
                                //     height: 0.5,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                Obx(
                                  () => ListView.builder(
                                    itemCount: controller.generalFields.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Obx(() => Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
                                                child: Text(
                                                  '- ${controller.arrGeneralFields[index].name ?? ''}${(controller.arrGeneralFields[index].required ?? 0) == 1 ? ': *' : ':'} ',
                                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Obx(
                                                () => (controller.generalFields[index]['type'] == "shorttext" || controller.generalFields[index]['type'] == "range")
                                                    ? shortTextWidget(context, (controller.generalFields[index]['controller']))
                                                    : (controller.generalFields[index]['type'] == "dropdown")
                                                        ? Obx(() => dropdownWidget(context, controller, index, true))
                                                        : Container(),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ),
                                Obx(
                                  () => ListView.builder(
                                    itemCount: controller.fields.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Obx(() => Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
                                                child: Text(
                                                  '- ${controller.arrCategoryOrderField[index].name ?? ''}${(controller.arrCategoryOrderField[index].required ?? 0) == 1 ? ': *' : ':'} ',
                                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              (controller.fields[index]['type'] == "shorttext" || controller.fields[index]['type'] == "range")
                                                  ? shortTextWidget(context, (controller.fields[index]['controller']))
                                                  : (controller.fields[index]['type'] == "dropdown")
                                                      ? dropdownWidget(context, controller, index, false)
                                                      : Container(),
                                            ],
                                          ));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                                  child: Text(
                                    '- ${AppLocalizations.of(context)!.remarks}: *',
                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.start,
                                  ),
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
                                        borderSide: BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
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
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                                  child: Text(
                                    '- ${AppLocalizations.of(context)!.deliveryDueDate}: *',
                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: AppLocalizations.of(context)!.selectDeliveryDueDate,
                                      hintStyle: const TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    controller: deliveryDueDateController,
                                    onTap: () {
                                      deliveryDueDateController.text = "${controller.deliveryDate.value.year}-${controller.deliveryDate.value.month}-${controller.deliveryDate.value.day}";
                                      showDateDialog(
                                          CupertinoDatePicker(
                                            initialDateTime: controller.deliveryDate.value,
                                            mode: CupertinoDatePickerMode.date,
                                            minimumDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                            ),
                                            use24hFormat: true,
                                            showDayOfWeek: false,
                                            onDateTimeChanged: (DateTime newDate) {
                                              controller.deliveryDate.value = newDate;
                                              deliveryDueDateController.text = "${controller.deliveryDate.value.year}-${controller.deliveryDate.value.month}-${controller.deliveryDate.value.day}";
                                            },
                                          ),
                                          context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                                  child: Text(
                                    '- ${AppLocalizations.of(context)!.priority}: *',
                                    style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Obx(
                                    () => ListView.builder(
                                      itemCount: controller.arrPriority.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Obx(() => Padding(
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
                                                        color: controller.selectedPriority.value == controller.arrPriority[index] ? ConstantColor.white : ConstantColor.black),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                                    child: Center(
                                                        child: Text(
                                                      controller.arrPriority[index],
                                                      style: TextStyle(
                                                          color: controller.selectedPriority.value == controller.arrPriority[index] ? ConstantColor.black : ConstantColor.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600),
                                                      textAlign: TextAlign.start,
                                                    ))),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.isEdit) {

                                        if (deliveryDueDateController.text.isEmpty) {
                                          ShowToast.showToast(AppLocalizations.of(context)!.pleaseSelectDeliveryDate);

                                        } else {

                                          List<Map<String, dynamic>> arrGeneralFields = [];
                                          var isComplete = true;

                                          for (var element in controller.generalFields) {

                                            Map<String, String> generalField = {};

                                            generalField['name'] = element['key'];

                                            if (element['type'] == 'shorttext') {

                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${generalField['name']}");
                                                isComplete = false;
                                                break;
                                              }

                                              generalField['value'] = element['controller'].text;

                                            } else if (element['type'] == 'range') {

                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${generalField['name']}");
                                                isComplete = false;
                                                break;
                                              }

                                              generalField['value'] = element['controller'].text;

                                            } else if (element['type'] == 'dropdown') {

                                              generalField['value'] = element['selectedValue'];
                                            }

                                            arrGeneralFields.add(generalField);
                                          }

                                          List<Map<String, dynamic>> arrOrderFields = [];

                                          for (var element in controller.fields) {

                                            Map<String, String> field = {};

                                            field['name'] = element['key'];

                                            if (element['type'] == 'shorttext') {

                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${field['name']}");
                                                isComplete = false;
                                                break;
                                              }

                                              field['value'] = element['controller'].text;

                                            } else if (element['type'] == 'range') {

                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${field['name']}");
                                                isComplete = false;
                                                break;
                                              }

                                              field['value'] = element['controller'].text;

                                            } else if (element['type'] == 'dropdown') {

                                              field['value'] = element['selectedValue'];

                                            }
                                            arrOrderFields.add(field);
                                          }

                                          if (isComplete) {
                                            Map<String, dynamic> bodyParams = {
                                              "id": controller.orderDetail.order_no!.split("/").last,
                                              "orderDate": controller.orderDetail.orderDate ?? '',
                                              "deliveryDate": deliveryDueDateController.text,
                                              "categoryId": controller.orderDetail.categoryId ?? '',
                                              "priority": controller.selectedPriority.value.split(" ").first.toLowerCase(),
                                              "remarks": remarksController.text,
                                              "clientId": "${controller.orderDetail.clientId ?? 0}",
                                              "extraGeneralFields": arrGeneralFields,
                                              "extraOrdersFields": arrOrderFields,
                                            };

                                            debugPrint("Add order params $bodyParams");

                                            controller.updateOrder(bodyParams).then((response) {
                                              print("Response ${response}");
                                              if (response['success'].toString() == "true") {
                                                Get.back(result: "added");
                                                ShowToast.showToast(response['message'].toString());
                                              } else {
                                                ShowToast.showToast(response['message'].toString());
                                              }
                                            });
                                          }
                                        }
                                      } else {
                                        if (controller.arrImages.isEmpty) {
                                          ShowToast.showToast("Please select any one image");
                                        } else if ((controller.clientDetail["name"] == null || controller.clientDetail["name"].isEmpty) && controller.userMap['role'] != 'client') {
                                          ShowToast.showToast("Please select client");
                                        } else if (deliveryDueDateController.text.isEmpty) {
                                          ShowToast.showToast("Please select delivery date");
                                        } else {
                                          List<Map<String, dynamic>> arrGeneralFields = [];
                                          for (var element in controller.generalFields) {
                                            Map<String, String> generalField = {};
                                            generalField['name'] = element['key'];
                                            if (element['type'] == 'shorttext') {
                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${generalField['name']}");
                                                break;
                                              }
                                              generalField['value'] = element['controller'].text;
                                            } else if (element['type'] == 'range') {
                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${generalField['name']}");
                                                break;
                                              }
                                              generalField['value'] = element['controller'].text;
                                            } else if (element['type'] == 'dropdown') {
                                              generalField['value'] = element['selectedValue'];
                                            }
                                            arrGeneralFields.add(generalField);
                                          }

                                          List<Map<String, dynamic>> arrOrderFields = [];
                                          for (var element in controller.fields) {
                                            Map<String, String> field = {};
                                            field['name'] = element['key'];
                                            if (element['type'] == 'shorttext') {
                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${field['name']}");
                                                break;
                                              }
                                              field['value'] = element['controller'].text;
                                            } else if (element['type'] == 'range') {
                                              if (element['required'] == "1" && element['controller'].text.isEmpty) {
                                                ShowToast.showToast("Please enter ${field['name']}");
                                                break;
                                              }
                                              field['value'] = element['controller'].text;
                                            } else if (element['type'] == 'dropdown') {
                                              field['value'] = element['selectedValue'];
                                            }
                                            arrOrderFields.add(field);
                                          }

                                          Map<String, dynamic> bodyParams = {
                                            "orderDate": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                            "deliveryDate": deliveryDueDateController.text,
                                            "categoryId": controller.categoryId,
                                            "priority": controller.selectedPriority.value.split(" ").first.toLowerCase(),
                                            "remarks": remarksController.text,
                                            "clientId": controller.userMap['role'] == 'client' ? controller.userMap['id'] : controller.clientDetail["id"],
                                            "extraGeneralFields": arrGeneralFields,
                                            "extraOrdersFields": arrOrderFields,
                                          };

                                          debugPrint("Add order params $bodyParams");

                                          controller.createOrder(bodyParams).then((response) async {
                                            print("Response ${response}");
                                            if (response['success'].toString() == "true") {
                                              controller.getAdminId("${response['id']}");
                                              Get.back();
                                              Get.back();
                                              ShowToast.showToast(response['message'].toString());
                                            } else {
                                              ShowToast.showToast(response['message'].toString());
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                        height: 60,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white, width: 1), color: Colors.white),
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                        child: Center(
                                            child: Text(
                                          AppLocalizations.of(context)!.placeOrder,
                                          style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 20, fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ))),
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

  void showDateDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
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

  Widget shortTextWidget(BuildContext context, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
              ),
            ),
            const Text(
              '',
              style: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Container(
          height: 0.5,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget dropdownWidget(BuildContext context, CreateOrderStepTwoController controller, int index, bool isGeneral) {
    return DropdownButton(
        value: isGeneral ? controller.generalFields[index]['selectedValue'] : controller.fields[index]['selectedValue'],
        padding: const EdgeInsets.symmetric(horizontal: 0),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: 'Montserrat'),
        iconEnabledColor: Colors.white,
        dropdownColor: ConstantColor.primary,
        isExpanded: true,
        items: (isGeneral ? controller.generalFields[index]['dropDownOptions'] : controller.fields[index]['dropDownOptions']),
        onChanged: (txt) {
          if (txt == null) return;
          if (isGeneral) {
            controller.generalFields[index]['selectedValue'] = txt;
            controller.isLoading(true);
            controller.isLoading(false);
          } else {
            controller.fields[index]['selectedValue'] = txt;
            controller.isLoading(true);
            controller.isLoading(false);
          }
        });
  }

  Widget rangeTextWidget(BuildContext context, TextEditingController fromController, TextEditingController toController) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: fromController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "From", hintStyle: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), counterText: ""),
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: toController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                      decoration:
                          const InputDecoration(border: InputBorder.none, hintText: "To", hintStyle: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400), counterText: ""),
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Text(
          'gm',
          style: TextStyle(color: ConstantColor.white, fontSize: 12, fontWeight: FontWeight.w400),
          textAlign: TextAlign.start,
        ),
      ],
    );

  }

  void _showImagePickerOptions(BuildContext context, CreateOrderStepTwoController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Select from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  controller.openPicker(false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.orange),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  controller.openPicker(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
