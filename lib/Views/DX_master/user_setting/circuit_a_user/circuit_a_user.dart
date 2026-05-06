import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/circuit_setting/circuit_selection_setting.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/condensor_fan_setting/condensor_fan_setting.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CircuitAUser extends StatefulWidget {
  const CircuitAUser({super.key});

  @override
  State<CircuitAUser> createState() => _CircuitAState();
}

class _CircuitAState extends State<CircuitAUser> {
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
                  Get.to(() => CircuitSelectionSetting());
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
                  Get.to(() => CondensorFanSetting());
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
