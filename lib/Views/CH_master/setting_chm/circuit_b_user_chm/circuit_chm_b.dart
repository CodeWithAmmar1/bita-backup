import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_b_user_chm/circuit_b_setting_chm/circuit_b_selection_setting_chm.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_b_user_chm/condensor_b_fan_setting_chm.dart/condensor_b_fan_setting_chm.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CircuitChmB extends StatefulWidget {
  const CircuitChmB({super.key});

  @override
  State<CircuitChmB> createState() => _CircuitAState();
}

class _CircuitAState extends State<CircuitChmB> {
  // final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'Circuit B Setting',
            style: TextStyle(
                fontSize: Get.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Get.to(() => CircuitBSelectionSettingChm());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  
                  title: Text(
                    'Circuit Settings'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => CondensorBFanSettingChm());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'Condensor Fan Settings'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: Get.height * 0.02),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => OilChange());
              //   },
              //   child: ListTile(
              //     leading: Icon(
              //       Icons.settings,
              //       color: Get.isDarkMode ? Colors.white : Colors.black,
              //     ),
              //     trailing: Icon(
              //       Icons.arrow_forward_ios_rounded,
              //       color: Get.isDarkMode ? Colors.white : Colors.black,
              //       size: 20,
              //     ),
              //     title: Text(
              //       'Oil Change Hours'.tr,
              //       style: TextStyle(
              //         color: Get.isDarkMode ? Colors.white : Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
