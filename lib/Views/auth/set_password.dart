import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/welcom_custom_widget.dart';
import 'package:testappbita/controller/auth_controller/auth_controller.dart';
import 'package:testappbita/controller/password_controller/password_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Setpassword extends StatefulWidget {
  const Setpassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SetpasswordState createState() => _SetpasswordState();
}

class _SetpasswordState extends State<Setpassword> {
  final AuthController _authController = Get.put(AuthController());
  final TextFieldController textFieldController =
      Get.put(TextFieldController());

  String? _errorMessage;

  void _validatePasswords() {
    setState(() {
      if (_authController.passwordController.text.isNotEmpty &&
          _authController.confirmPasswordController.text.isNotEmpty &&
          _authController.passwordController.text !=
              _authController.confirmPasswordController.text) {
        _errorMessage = "Passwords do not match";
      } else {
        _errorMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Set Your Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => TextField(
                onChanged: (value) {
                  textFieldController.checkFields();
                  _validatePasswords();
                },
                controller: _authController.passwordController,
                obscureText: textFieldController.isPasswordVisible.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      textFieldController.togglePasswordVisibility();
                    },
                    icon: textFieldController.isPasswordVisible.value
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.remove_red_eye),
                    color: ThemeColor().actual,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Get.isDarkMode
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Colors.white,
                  hintText: "Password",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => TextField(
                onChanged: (value) {
                  textFieldController.checkFields();
                  _validatePasswords();
                },
                controller: _authController.confirmPasswordController,
                obscureText: textFieldController.hideconfrim.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      textFieldController.toggleConfirmPasswordVisibility();
                    },
                    icon: textFieldController.hideconfrim.value
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.remove_red_eye),
                    color: ThemeColor().actual,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Get.isDarkMode
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Colors.white,
                  hintText: "Confirm Password",
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            const Spacer(),
            Center(
              child: Obx(() {
                return _authController.isLoading.value
                    ? CircularProgressIndicator(color: Color(0xFF28C38F))
                    : RoundRectangleButton(
                        size: Get.width * 0.88,
                        text: "REGISTER",
                        color: const Color(0xFF28C38F),
                        onTap: () async {
                          _authController.isLoading.value = true;
                          await _authController.signupFun(context);
                          _authController.isLoading.value = false;
                        },
                      );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
