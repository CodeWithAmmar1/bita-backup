import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/auth/forget_password.dart';
import 'package:testappbita/Views/auth/signup_screen.dart';
import 'package:testappbita/Views/auth/welcom_custom_widget.dart';
import 'package:testappbita/controller/auth_controller/auth_controller.dart';
import 'package:testappbita/controller/password_controller/password_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Signin extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final PasswordController passwordController = Get.put(PasswordController());
  final TextFieldController textFieldController =
      Get.put(TextFieldController());
  final RxBool isChecked = false.obs;

  Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom, // Keyboard height
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * 0.07),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Welcome to BITA HOME",
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // 👇 Your Form Widgets (Email, Password etc.)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Get.isDarkMode
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.01)),
                            ),
                            width: Get.width * 0.9,
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (value) =>
                                      textFieldController.checkFields(),
                                  controller:
                                      _authController.signinEmailController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.email, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintText: "BITA HOME ID (Email)",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.6)),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.transparent,
                                      width: Get.width * 0.1,
                                      height: 1,
                                    ),
                                    Container(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: Get.width * 0.78,
                                      height: 1,
                                    ),
                                  ],
                                ),
                                Obx(() => TextField(
                                      onChanged: (value) =>
                                          textFieldController.checkFields(),
                                      controller: _authController
                                          .signinPasswordController,
                                      obscureText: passwordController
                                          .isPasswordVisible.value,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            passwordController.isPasswordVisible
                                                .toggle();
                                          },
                                          icon: Icon(
                                            passwordController
                                                    .isPasswordVisible.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: ThemeColor().actual,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Center(
                        child: Column(
                          children: [
                            Obx(() {
                              return _authController.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: Color(0xFF28C38F),
                                    )
                                  : RoundRectangleButton(
                                      size: Get.width * 0.88,
                                      text: "LOGIN",
                                      color: Color(0xFF28C38F),
                                      onTap: () async {
                                        _authController.isLoading.value = true;
                                        await _authController
                                            .signinFun(context);
                                        _authController.isLoading.value = false;
                                      },
                                    );
                            }),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.offAll(SignupScreen());
                                      _authController.signinEmailController
                                          .clear();
                                      _authController.signinPasswordController
                                          .clear();
                                    },
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF28C38F),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(Forgetpassword());
                                    },
                                    child: Text(
                                      "FORGOT PASSWORD?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF28C38F),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//remeber me part
  // SizedBox(
                //   height: 20,
                // ),
                // Obx(() => GestureDetector(
                //       onTap: () => isChecked.value = !isChecked.value,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(left: 10),
                //             child: Container(
                //               width: 20,
                //               height: 20,
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                     color: isChecked.value
                //                         ? Color(0xFF28C38F)
                //                         : Colors.grey),
                //                 shape: BoxShape.circle,
                //                 color: isChecked.value
                //                     ? Color(0xFF28C38F)
                //                     : Colors.transparent,
                //               ),
                //               child: isChecked.value
                //                   ? Icon(
                //                       Icons.check,
                //                       color: Colors.white,
                //                       size: 18,
                //                     )
                //                   : null,
                //             ),
                //           ),
                //           SizedBox(width: 6),
                //           Text(
                //             isChecked.value ? "Remember Me" : "Remember Me",
                //             style: TextStyle(
                //               fontSize: 12,
                //             ),
                //           ),
                //         ],
                //       ),
                //     )),
              
              