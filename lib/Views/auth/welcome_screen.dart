import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/signin_screen.dart';
import 'package:testappbita/Views/auth/signup_screen.dart';
import 'package:testappbita/Views/auth/welcom_custom_widget.dart';
import 'package:testappbita/controller/button_controller/button_controller.dart';

class WelcomeScreen extends StatelessWidget {
  final ButtonController controller = Get.put(ButtonController());

  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.09,
          ),
          Image.asset(
            "assets/images/icon.png",
            width: Get.width * 0.5,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: Get.height * 0.26,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.buttons.map((btn) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RoundRectangleButton(
                        size: Get.width * 0.75,
                        text: btn.text,
                        color: Color(0xFF28C38F),
                        onTap: () {
                          if (btn.text == "LOGIN") {
                            Get.to(() => Signin());
                          } else if (btn.text == "REGISTER") {
                            Get.to(() => SignupScreen());
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
