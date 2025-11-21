import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/clients/add_client_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/auth/verify_otp_screen.dart';
import 'package:gdgold/pages/orders/create_order_step_two_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class AddClientScreen extends StatelessWidget {
  AddClientScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final companyNameController = TextEditingController();
  final mobileController = TextEditingController();
  final codeController = TextEditingController();
  final emailController = TextEditingController();
  final pinCodeController = TextEditingController();
  final dobController = TextEditingController();
  final anniversaryDateController = TextEditingController();
  final countryTextController = TextEditingController();
  final stateTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final remarksController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<AddClientController>(
      init: AddClientController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.addClient, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.clientName}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.companyName}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: companyNameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.password}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.confirmPassword}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: confirmPasswordController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.mobileNo}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          Row(
                            children: [
                              CountryCodePicker(
                                flagWidth: 20,
                                padding: EdgeInsets.zero,
                                onChanged: (value) {
                                  codeController.text = value.dialCode.toString();
                                },
                                onInit: (code) {
                                  codeController.text = code!.dialCode.toString();
                                  debugPrint("on init ${code.name} ${code.dialCode} ${code.name}");
                                },
                                initialSelection: 'IN',
                                textStyle: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: mobileController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 13,
                                  style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 10,),
                                      hintText: "",
                                      border: InputBorder.none,
                                      counterText: ""
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.email}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                            child: CountryStateCityPicker(
                                country: countryTextController,
                                state: stateTextController,
                                city: cityTextController,
                                textFieldDecoration: InputDecoration(contentPadding: const EdgeInsets.only(top: 10.0, left: 0.0),
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(0.0), borderSide: const BorderSide(
                                      width: 4, color: Colors.white)),
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(0.0), borderSide: const BorderSide(
                                      width: 0.5, color: Colors.white)),
                                  hintStyle: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                                  filled: true,
                                  labelStyle: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.address}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: addressController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.pincode}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: pinCodeController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.gST}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: gstController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.dateOfBirth}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.select,
                              suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                              hintStyle: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: dobController,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            onTap: () {
                              showDateDialog(CupertinoDatePicker(
                                initialDateTime: controller.dob.value,
                                mode: CupertinoDatePickerMode.date,
                                maximumDate: DateTime.now(),
                                use24hFormat: true,
                                showDayOfWeek: false,
                                onDateTimeChanged: (DateTime newDate) {
                                  controller.dob.value = newDate;
                                  dobController.text = "${controller.dob.value.day}-${controller.dob.value.month}-${controller.dob.value.year}";
                                },
                              ), context);
                            },
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 0.0),
                            child: Text('- ${AppLocalizations.of(context)!.anniversaryDate}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.select,
                              suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                              hintStyle: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: anniversaryDateController,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            onTap: () {
                              showDateDialog(CupertinoDatePicker(
                                initialDateTime: controller.anniversaryDate.value,
                                mode: CupertinoDatePickerMode.date,
                                maximumDate: DateTime.now(),
                                use24hFormat: true,
                                showDayOfWeek: false,
                                onDateTimeChanged: (DateTime newDate) {
                                  controller.anniversaryDate.value = newDate;
                                  anniversaryDateController.text = "${controller.anniversaryDate.value.day}-${controller.anniversaryDate.value.month}-${controller.anniversaryDate.value.year}";
                                },
                              ), context);
                            },
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text('- ${AppLocalizations.of(context)!.remarks}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          SizedBox(
                            height: 100,
                            child: TextFormField(
                              maxLines: 3,
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                labelText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white), //<-- SEE HERE
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
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                if (nameController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterName);
                                } else if (companyNameController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterCompanyName);
                                } else if (passwordController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterPassword);
                                } else if (confirmPasswordController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterConfirmPassword);
                                } else if (mobileController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterMobileNumber);
                                } else if (emailController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterEmail);
                                } else if (countryTextController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterCountry);
                                } else if (stateTextController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterState);
                                } else if (cityTextController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterCity);
                                } else if (addressController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterAddress);
                                } else if (controller.dob.value == DateTime.now()) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterValidDateOfBirth);
                                } else {

                                  Map<String, String> bodyParams = {
                                    'phoneNumber': codeController.text.toString() + mobileController.text.toString(),
                                    'password': passwordController.text.toString(),
                                    'email': emailController.text.toString(),
                                    'full_name': nameController.text.toString(),
                                    'company_name': companyNameController.text.toString(),
                                    'country': countryTextController.text.toString(),
                                    'state': stateTextController.text.toString(),
                                    'city': cityTextController.text.toString(),
                                    'pincode': pinCodeController.text.toString(),
                                    'dob': dobController.text.toString(),
                                    'anniversarydate': anniversaryDateController.text.toString(),
                                    'remark': remarksController.text.toString(),
                                    'address': addressController.text.toString(),
                                    'gst': gstController.text.toString(),
                                    "role": "client",
                                  };
                                  print("Register params ${bodyParams}");

                                  controller.register(bodyParams).then((response) {
                                    if (response['success'].toString() == "true") {

                                      Get.back(result: "added");

                                      ShowToast.showToast(response['message'].toString());
                                    } else {
                                      ShowToast.showToast(response['message'].toString());
                                    }
                                  });

                                //   Map<String, String> bodyParams = {
                                //     'phoneNumber': codeController.text.toString() + mobileController.text.toString(),
                                //   };
                                //   print("Send code params ${bodyParams}");
                                //
                                //   controller.sendCode(bodyParams).then((response) {
                                //
                                //     if (response['success'].toString() == "true") {
                                //
                                //       var argument = {
                                //         'isFromAddClient': true,
                                //         'phoneNumber': codeController.text.toString() + mobileController.text.toString(),
                                //         'password': passwordController.text.toString(),
                                //         'email': emailController.text.toString(),
                                //         'fullName': nameController.text.toString(),
                                //         'companyName': companyNameController.text.toString(),
                                //         'country': countryTextController.text.toString(),
                                //         'state': stateTextController.text.toString(),
                                //         'city': cityTextController.text.toString(),
                                //         'pincode': pinCodeController.text.toString(),
                                //         'dob': dobController.text.toString(),
                                //         'anniversarydate': anniversaryDateController.text.toString(),
                                //         'remark': remarksController.text.toString(),
                                //         'address': addressController.text.toString(),
                                //         'gst': gstController.text.toString(),
                                //       };
                                //
                                //       Get.to(VerifyOtpScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300))!.then((onValue) {
                                //         if (onValue == "added") {
                                //           Get.back(result: "added");
                                //         }
                                //       });
                                //
                                //     } else {
                                //       ShowToast.showToast(response['message'].toString());
                                //     }
                                //   });
                                }

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
                                  child: Center(child: Text(AppLocalizations.of(context)!.submit, style: const TextStyle(color: ConstantColor.gradientTopColor, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.start,))
                              ),
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