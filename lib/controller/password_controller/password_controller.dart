import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  var isPasswordVisible = true.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

class TextFieldController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isButtonEnabled = false.obs;
  var isPasswordVisible = true.obs;
  var hideconfrim = true.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    hideconfrim.value = !hideconfrim.value;
  }

  void checkFields() {
    isButtonEnabled.value =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }
}
