import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:testappbita/controller/splash_controller/splash_controller.dart';

class Splash extends StatelessWidget {
  Splash({super.key}) {
    Get.put(SplashController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFC1C1),
                  Color(0xFFB2FF59),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child:
                Image.asset("assets/images/splash.png", width: Get.width * 0.9),
          ),
        ],
      ),
    );
  }
}
