import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/auth/verify_otp_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:gdgold/themes/responsive.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../l10n/app_localizations.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({Key? key}) : super(key: key);

  final otpController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    var phoneNumber = "";
    var password = "";
    var email = "";
    var fullName = "";
    var companyName = "";
    var country = "";
    var state = "";
    var city = "";
    var pincode = "";
    var dob = "";
    var anniversarydate = "";
    var remark = "";
    var address = "";
    var gst = "";
    var isFromAddClient = false;

    if (Get.arguments != null) {
      phoneNumber = Get.arguments['phoneNumber'].toString();
      password = Get.arguments['password'].toString();
      email = Get.arguments['email'].toString();
      fullName = Get.arguments['fullName'].toString();
      companyName = Get.arguments['companyName'].toString();
      country = Get.arguments['country'].toString();
      city = Get.arguments['city'].toString();
      state = Get.arguments['state'].toString();
      pincode = Get.arguments['pincode'].toString();
      dob = Get.arguments['dob'].toString();
      anniversarydate = Get.arguments['anniversarydate'].toString();
      remark = Get.arguments['remark'].toString();
      address = Get.arguments['address'].toString();
      gst = Get.arguments['gst'].toString();
      if (Get.arguments['isFromAddClient']!= null && Get.arguments['isFromAddClient']) {
        isFromAddClient = true;
      }
    }

    return GetX<VerifyOtpController>(
      init: VerifyOtpController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            controller.isSendCodeLoading.value = false;
            controller.isVerifyLoading.value = false;
            return true;
          },
          child: Stack(
            children: [
              Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [ConstantColor.gradientTopColor, ConstantColor.gradientBottomColor],
                        stops: [0.0, 0.67]),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: Responsive.height(20, context), left: 30, right: 30, bottom: 10),
                              child: const Text('GP Gold', style: TextStyle(color: ConstantColor.white, fontSize: 40, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.codeSentTo} ${email.toString()}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 10.0,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: PinCodeTextField(
                                        controller: otpController,
                                        appContext: context,
                                        length: 6,
                                        autoFocus: true,
                                        blinkWhenObscuring: true,
                                        animationType: AnimationType.fade,
                                        pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius: BorderRadius.circular(5),
                                            fieldHeight: 47,
                                            fieldWidth: 47,
                                            activeColor: Colors.white,
                                            inactiveColor: Colors.white,
                                            inactiveFillColor: Colors.white,
                                            activeFillColor: Colors.white,
                                            selectedFillColor: const Color(0xffdadada),
                                            selectedColor: const Color(0xffdadada)),
                                        enableActiveFill: true,
                                        keyboardType: TextInputType.number,
                                        boxShadows: const [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Colors.black12,
                                            blurRadius: 10,
                                          )
                                        ],
                                        onCompleted: (v) {},
                                        onChanged: (value) {},
                                        beforeTextPaste: (text) {
                                          return true;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [ConstantColor.gradientBottomColor, ConstantColor.gradientBottomColor],
                                          stops: [0.0215, 1]),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent, disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12), shadowColor: Colors.transparent, elevation: 0),
                                      onPressed: () async {
                                        FocusScope.of(context).requestFocus(FocusNode());

                                        if (otpController.text.trim().isEmpty) {
                                          ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterOtp);
                                        } else {
                                          Map<String, String> bodyParams = {
                                            "phoneNumber": phoneNumber,
                                            "otpCode": otpController.text.toString(),  // Code received via SMS
                                            "password": password,
                                            "role": "client",
                                            "email": email,
                                            "full_name": fullName,
                                            "company_name": companyName,
                                            "country": country,
                                            "state": state,
                                            "city": city,
                                            "pincode": pincode,
                                            "dob": dob,
                                            "anniversarydate": anniversarydate,
                                            "remark": remark,
                                            "gst": gst,
                                            "address": address
                                          };
                                          print("Register params ${bodyParams}");

                                          controller.register(bodyParams).then((response) {
                                            if (response['success'].toString() == "true") {

                                              controller.getAdminId(fullName);
                                              if (isFromAddClient) {
                                                Get.back(result: "added");
                                              } else {
                                                Get.offAll(LoginScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
                                              }
                                              ShowToast.showToast(response['message'].toString());
                                            } else {
                                              ShowToast.showToast(response['message'].toString());
                                            }
                                          });
                                        }
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.verify,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Visibility(visible: controller.isSendCodeLoading.value, child: const Padding(
                                              padding:  EdgeInsets.only(left: 5.0),
                                              child: Center(child: CupertinoActivityIndicator(animating: true, radius: 8, color: Colors.white)),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: !controller.isTimerOn.value
                                        ? RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "${AppLocalizations.of(context)!.didNotReceivedOTPCode}?\n",
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                                          ),
                                          TextSpan(
                                              text: AppLocalizations.of(context)!.resendCode,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: ConstantColor.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {

                                                //   Map<String, String> bodyParams = {
                                                //     'value': isLoginType == 'phone'
                                                //         ? countryCode.replaceAll("+", "").toString() + isValue.toString()
                                                //         : isValue.toString(),
                                                //     'type': isLoginType,
                                                //     'device_token': deviceToken
                                                //   };
                                                //
                                                // controller.sendCode(bodyParams);
                                                }),
                                        ]))
                                        : Text(
                                      "${AppLocalizations.of(context)!.resendCodeIn} ${controller.codeRemainingSeconds.value} ${AppLocalizations.of(context)!.seconds}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: ConstantColor.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(child: controller.isLoading.value ? const Loader() : Container())
            ],
          ),
        );
      },
    );
  }
}
