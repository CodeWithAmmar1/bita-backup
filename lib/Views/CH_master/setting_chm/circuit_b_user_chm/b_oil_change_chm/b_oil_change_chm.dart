import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/utils/theme/theme.dart';

class BOilChange extends StatelessWidget {
  const BOilChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'Oil Change Hours',
          style: TextStyle(
              fontSize: Get.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.isDarkMode
                      ? ThemeColor().mode2Sec
                      : ThemeColor().mode1Sec,
                  border: Border.all(color: ThemeColor().actual)),
              child: Center(
                child: Text(
                  "222 Hr",
                  style: TextStyle(
                    fontFamily: 'DS-Digital',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
