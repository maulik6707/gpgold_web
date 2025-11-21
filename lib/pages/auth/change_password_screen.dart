import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/auth/change_password_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';

import '../../l10n/app_localizations.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<ChangePasswordController>(
      init: ChangePasswordController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.changePassword, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                            child: Text('- ${AppLocalizations.of(context)!.currentPassword}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: currentPassword,
                            keyboardType: TextInputType.text,
                            obscureText: !controller.showCurrentPassword.value,//This will o
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !controller.showCurrentPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  controller.showCurrentPassword.value = !controller.showCurrentPassword.value;
                                },
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text('- ${AppLocalizations.of(context)!.newPassword}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: newPassword,
                            keyboardType: TextInputType.text,
                            obscureText: !controller.showNewPassword.value,//This will o
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !controller.showNewPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  controller.showNewPassword.value = !controller.showNewPassword.value;
                                },
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text('- ${AppLocalizations.of(context)!.confirmPassword}:', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: confirmPassword,
                            keyboardType: TextInputType.text,
                            obscureText: !controller.showConfirmPassword.value,//This will o
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !controller.showConfirmPassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  controller.showConfirmPassword.value = !controller.showConfirmPassword.value;
                                },
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                if (currentPassword.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterCurrentPassword);
                                } else if (newPassword.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterNewPassword);
                                } else if (confirmPassword.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterConfirmPassword);
                                } else if (confirmPassword.text.trim() != newPassword.text.trim()) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.passwordDoesNotMatch);
                                } else {
                                  Map<String, String> bodyParams = {
                                    "currentPassword": currentPassword.text,
                                    "newPassword": newPassword.text,
                                  };
                                  print("changePassword params ${bodyParams}");

                                  controller.changePassword(bodyParams).then((response) {
                                    if (response['success'] == true) {
                                      Get.back();
                                      ShowToast.showToast(response['message'].toString());
                                    } else {
                                      ShowToast.showToast(response['message'].toString());
                                    }
                                  });
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
}