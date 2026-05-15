import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_a&b_chm/circuit_A/circuit_setting_chm/circuit_selection_setting_chm.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_a&b_chm/circuit_A/condensor_fan_setting_chm/condensor_fan_setting_chm.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CircuitAUserChm extends StatefulWidget {
  const CircuitAUserChm({super.key});

  @override
  State<CircuitAUserChm> createState() => _CircuitAState();
}

class _CircuitAState extends State<CircuitAUserChm> {
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
            'Circuit A Setting',
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
                  Get.to(() => CircuitSelectionSettingChm());
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
                  Get.to(() => CondensorFanSettingChm());
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
