import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final Future<bool> Function()? onTap;
  final String title;

  const CustomToggle({
    super.key,
    required this.value,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // SizedBox(width: 10,),
        Padding(
          padding: const EdgeInsets.only(left:  15.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(right:  15.0),
          child: LoadSwitch(
            height: Get.height * 0.038,
            width: Get.height * 0.08,
            value: value,
            future: onTap,
            onChange: (_) {},
            onTap: (val) {
              log("Tapped while value is $val");
            },
            animationDuration: const Duration(milliseconds: 300),
            curveIn: Curves.easeInBack,
            curveOut: Curves.easeOutBack,
            style: SpinStyle.material,
            switchDecoration: (value, loading) => BoxDecoration(
              color: value
                  ? ThemeColor().actual.withValues(alpha: 0.2)
                  : Colors.red[100],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: value
                      ? ThemeColor().actual.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            spinColor: (value) => value
                ? ThemeColor().actual
                : const Color.fromARGB(255, 255, 77, 77),
            spinStrokeWidth: 3,
            thumbDecoration: (value, loading) => BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: value
                      ? ThemeColor().actual.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
              
      ],
    );
  }
}
