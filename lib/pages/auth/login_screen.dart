import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/auth/login_controller.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/model/login_user_model.dart';
import 'package:gdgold/pages/auth/forgot_password_screen.dart';
import 'package:gdgold/pages/home_screen.dart';
import 'package:gdgold/pages/auth/register_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:gdgold/themes/responsive.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
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
                        colors: [
                          ConstantColor.gradientTopColor,
                          ConstantColor.gradientTopColor
                        ],
                        stops: [
                          0.0,
                          0.67
                        ]),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Responsive.height(15, context)),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                    'assets/icon/launcher_logo.png',
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 30, right: 30, bottom: 50),
                              child: Text('GP Gold',
                                  style: TextStyle(
                                      color: ConstantColor.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: CountryCodePicker(
                                          flagWidth: 20,
                                          padding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            codeController.text =
                                                value.dialCode.toString();
                                          },
                                          onInit: (code) {
                                            codeController.text =
                                                code!.dialCode.toString();
                                            debugPrint(
                                                "on init ${code.name} ${code.dialCode} ${code.name}");
                                          },
                                          initialSelection: 'IN',
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                          showCountryOnly: false,
                                          showOnlyCountryWhenClosed: false,
                                          alignLeft: false,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: TextField(
                                            controller: phoneController,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 13,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .enterYourPhoneNumber,
                                                border: InputBorder.none,
                                                counterText: ""),
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
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: passwordController,
                                        obscureText:
                                            !controller.showPassword.value,
                                        //This will obscure text dynamically
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .enterYourPassword,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              !controller.showPassword.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            onPressed: () {
                                              controller.showPassword.value =
                                                  !controller
                                                      .showPassword.value;
                                            },
                                          ),
                                        ),
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
                                          colors: [
                                            ConstantColor.gradientBottomColor,
                                            ConstantColor.gradientBottomColor
                                          ],
                                          stops: [
                                            0.0215,
                                            1
                                          ]),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          disabledForegroundColor: Colors
                                              .transparent
                                              .withOpacity(0.38),
                                          disabledBackgroundColor: Colors
                                              .transparent
                                              .withOpacity(0.12),
                                          shadowColor: Colors.transparent,
                                          elevation: 0),
                                      onPressed: () async {
                                        if (phoneController.text.isEmpty) {
                                          ShowToast.showToast(
                                              "Please enter mobile number"
                                                  .toString());
                                        } else if (passwordController
                                            .text.isEmpty) {
                                          ShowToast.showToast(
                                              "Please enter password"
                                                  .toString());
                                        } else {
                                          var fCMToken =
                                              await SharPreferences.getString(
                                                      'FCMToken') ??
                                                  "";
                                          print("fCMToken");
                                          print(await SharPreferences.getString(
                                                  'fCMToken') ??
                                              "");
                                          // var status = await OneSignal.();

                                          Map<String, String> bodyParams = {
                                            'phoneNumber': codeController.text
                                                    .toString() +
                                                phoneController.text.toString(),
                                            'password': passwordController.text
                                                .toString(),
                                          };
                                          print("Login params ${bodyParams}");

                                          controller
                                              .login(bodyParams)
                                              .then((response) async {
                                            if (response['success'] == true) {
                                              LoginUserModel loggedInUser =
                                                  LoginUserModel.fromJson(
                                                      response['user']);

                                              if (loggedInUser.role ==
                                                  "admin") {
                                                await FirebaseFirestore.instance
                                                    .collection("adminFCMToken")
                                                    .doc("${loggedInUser.id}")
                                                    .set({
                                                  'adminId': loggedInUser.id,
                                                  'adminName':
                                                      loggedInUser.fullName,
                                                  'adminToken':
                                                      await SharPreferences
                                                              .getString(
                                                                  'FCMToken') ??
                                                          ""
                                                });
                                              }

                                              SharPreferences.setString(
                                                  'LoggedInUser',
                                                  json.encode(
                                                      loggedInUser.toJson()));
                                              SharPreferences.setString(
                                                  'AccessToken',
                                                  "Bearer ${response['token']}");
                                              SharPreferences.setBoolean(
                                                  'isLogin', true);
                                              Map<String, dynamic> params = {
                                                'client_id':
                                                    loggedInUser.id ?? 0,
                                                'player_id': fCMToken
                                              };
                                              print(
                                                  "updateClientForNotification params ${params}");
                                              controller
                                                  .updateClientForNotification(
                                                      params)
                                                  .then((responseData) async {
                                                ShowToast.showToast(
                                                    response['message']
                                                        .toString());
                                                Get.offAll(HomeScreen(),
                                                    transition:
                                                        Transition.rightToLeft,
                                                    duration: const Duration(
                                                        milliseconds: 300));
                                              });
                                            } else {
                                              ShowToast.showToast(
                                                  response['message']
                                                      .toString());
                                            }
                                          });
                                        }
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .login,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const Visibility(
                                                visible: false,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Center(
                                                      child:
                                                          CupertinoActivityIndicator(
                                                              animating: true,
                                                              radius: 8,
                                                              color: Colors
                                                                  .white)),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(RegisterScreen(),
                                          transition: Transition.rightToLeft,
                                          duration: const Duration(
                                              milliseconds: 300));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        '${AppLocalizations.of(context)!.notRegistered}? ${AppLocalizations.of(context)!.register}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(ForgotPasswordScreen(),
                                          transition: Transition.rightToLeft,
                                          duration: const Duration(
                                              milliseconds: 300));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
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
              Container(
                  child:
                      controller.isLoading.value ? const Loader() : Container())
            ],
          ),
        );
      },
    );
  }
}
