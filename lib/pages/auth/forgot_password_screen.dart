import 'package:flutter/material.dart';
import 'package:gdgold/controller/auth/forgot_password_controller.dart';
import 'package:gdgold/pages/auth/verify_otp_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

final forgotPasswordController = Get.put(ForgotPasswordController());

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password",
            style: TextStyle(
                color: ConstantColor.white,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ConstantColor.gradientTopColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: TextField(
                controller: forgotPasswordController.emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: ConstantColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(VerifyOtpScreen()),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ConstantColor.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text("Send OTP"),
                )),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ConstantColor.gradientTopColor,
    );
  }
}
