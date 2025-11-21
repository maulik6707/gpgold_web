import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/auth/register_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/pages/auth/verify_otp_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:gdgold/themes/responsive.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final companyNameController = TextEditingController();

  final countryTextController = TextEditingController();
  final stateTextController = TextEditingController();
  final cityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<RegisterController>(
      init: RegisterController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            controller.isSendCodeLoading.value = false;
            controller.isVerifyLoading.value = false;
            return true;
          },
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ConstantColor.gradientTopColor, ConstantColor.gradientTopColor],
                    stops: [0.0, 0.67]),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Responsive.height(15, context), left: 30, right: 30, bottom: 50),
                            child: const Text('GP Gold', style: TextStyle(color: ConstantColor.white, fontSize: 40, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10.0,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: CountryCodePicker(
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
                                        textStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: TextField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 13,
                                          decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10,),
                                              hintText: AppLocalizations.of(context)!.enterYourPhoneNumber,
                                              border: InputBorder.none,
                                              counterText: ""
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: passwordController,
                                      obscureText: !controller.showPassword.value,//This will obscure text dynamically
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!.enterYourPassword,
                                        // Here is key idea
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            !controller.showPassword.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            controller.showPassword.value = !controller.showPassword.value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: confirmPasswordController,
                                      obscureText: !controller.confirmShowPassword.value,//This will obscure text dynamically
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!.confirmYourPassword,
                                        // Here is key idea
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            !controller.confirmShowPassword.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            controller.confirmShowPassword.value = !controller.confirmShowPassword.value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!.email,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: fullNameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!.fullName,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: companyNameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!.companyName,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: CountryStateCityPicker(
                                    country: countryTextController,
                                    state: stateTextController,
                                    city: cityTextController,
                                    textFieldDecoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                                      fillColor: Colors.white,
                                      filled: true,
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                                    )
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

                                      if (phoneController.text.isEmpty) {
                                        ShowToast.showToast("Please enter mobile number".toString());
                                      } else if (passwordController.text.isEmpty) {
                                        ShowToast.showToast("Please enter password".toString());
                                      } else if (confirmPasswordController.text.isEmpty) {
                                        ShowToast.showToast("Please enter confirm password".toString());
                                      } else if (emailController.text.isEmpty) {
                                        ShowToast.showToast("Please enter email".toString());
                                      } else if (fullNameController.text.isEmpty) {
                                        ShowToast.showToast("Please enter name".toString());
                                      } else if (companyNameController.text.isEmpty) {
                                        ShowToast.showToast("Please enter company name".toString());
                                      } else if (countryTextController.text.isEmpty) {
                                        ShowToast.showToast("Please enter country".toString());
                                      } else if (stateTextController.text.isEmpty) {
                                        ShowToast.showToast("Please enter state".toString());
                                      } else if (cityTextController.text.isEmpty) {
                                        ShowToast.showToast("Please enter city".toString());
                                      } else {

                                        Map<String, String> bodyParams = {
                                          'email': emailController.text.toString(),
                                        };
                                        print("Send code params ${bodyParams}");

                                        controller.sendCode(bodyParams).then((response) {

                                          if (response['success'].toString() == "true") {

                                            var argument = {
                                              'phoneNumber': codeController.text.toString() + phoneController.text.toString(),
                                              'password': passwordController.text.toString(),
                                              'email': emailController.text.toString(),
                                              'fullName': fullNameController.text.toString(),
                                              'companyName': companyNameController.text.toString(),
                                              'country': countryTextController.text.toString(),
                                              'state': stateTextController.text.toString(),
                                              'city': cityTextController.text.toString(),
                                            };

                                            Get.to(VerifyOtpScreen(), arguments: argument, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));

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
                                            AppLocalizations.of(context)!.createAccount,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600
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
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 16, bottom: 50),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      const TextSpan(
                                        text: "By Continuing, you agree to our ",
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                      TextSpan(
                                          text: "Privacy Policy",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              debugPrint("canLaunch");
                                              // var url = "https://www.google.com/";
                                              // if (await canLaunch(url)) {
                                              //   debugPrint("canLaunch");
                                              //   await launch(url);
                                              // } else {
                                              //   throw 'Could not launch $url';
                                              // }
                                            }),
                                      const TextSpan(
                                        text: " and our ",
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                      TextSpan(
                                          text: "Terms of Services",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              // var url = "https://www.google.com/";
                                              // if (await canLaunch(url)) {
                                              //   await launch(url);
                                              // } else {
                                              //   throw 'Could not launch $url';
                                              // }
                                            }),
                                    ]))),
                            ],
                          )
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
}
