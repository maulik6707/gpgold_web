import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/controller/karigar/add_karigar_controller.dart';
import 'package:gdgold/helper/show_toast.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:gdgold/themes/loader.dart';
import 'package:get/get.dart';
import '../../l10n/app_localizations.dart';

class AddKarigarScreen extends StatelessWidget {
  AddKarigarScreen({Key? key}) : super(key: key);

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetX<AddKarigarController>(
      init: AddKarigarController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.isLoading.value = false;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.addKarigar, style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
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
                            child: Text('- ${AppLocalizations.of(context)!.karigarName}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
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
                            child: Text('- ${AppLocalizations.of(context)!.city}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          TextField(
                            controller: cityController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: ""
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5.0),
                            child: Text('- ${AppLocalizations.of(context)!.mobileNo}: *', style: const TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ConstantColor.gradientTopColor,
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
                                    color: Colors.black,
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
                                    textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 13,
                                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 10,),
                                          hintText: AppLocalizations.of(context)!.enterYourPhoneNumber,
                                          border: InputBorder.none,
                                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
                                          counterText: ""
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 0.5, color: Colors.white,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                if (nameController.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterKarigarName);
                                } else if (cityController.text.trim().isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterCity);
                                } else if (phoneController.text.isEmpty) {
                                  ShowToast.showToast(AppLocalizations.of(context)!.pleaseEnterMobileNumber);
                                } else {
                                  Map<String, String> bodyParams = {
                                    "name": nameController.text,
                                    "city": cityController.text,
                                    'phoneNumber': codeController.text.toString() + phoneController.text.toString(),
                                  };

                                  print("Add Karigar params ${bodyParams}");

                                  controller.addKarigar(bodyParams).then((response) {
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