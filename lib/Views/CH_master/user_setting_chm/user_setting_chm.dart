import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_a&b_chm/circuit_A/circuit_setting_chm/circuit_selection_setting_chm.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_b_user_chm/circuit_chm_b.dart';
import 'package:testappbita/Views/CH_master/user_setting_chm/circuit_a_user_chm/circuit_a_user_chm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/button/custom_toggle.dart';
import 'package:testappbita/utils/theme/theme.dart';

class UserSettingChm extends StatelessWidget {
  UserSettingChm({super.key});
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'System Setting',
          style: TextStyle(
              fontSize: Get.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              SizedBox(height: 20),
              Obx(
                () => CustomToggle(
                  title: 'Circuit A'.tr,
                  value: _mqttController.circuitAenable.value,
                  onTap: () async {
                    _mqttController.circuitALoading.value = true;
                    final newValue = !_mqttController.circuitAenable.value;
                    // await _mqttController.enableCircuitA(newValue);
                    _mqttController.circuitALoading.value = false;
                    return newValue;
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Obx(
                () => CustomToggle(
                  title: 'Circuit B'.tr,
                  value: _mqttController.circuitBenable.value,
                  onTap: () async {
                    _mqttController.circuitBLoading.value = true;
                    final newValue = !_mqttController.circuitBenable.value;
                    await _mqttController.enableCircuitB(newValue);
                    _mqttController.circuitBLoading.value = false;
                    return newValue;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => RestartToggleChm(
                  leftText: ' Temp \nSensor'.tr,
                  rightText: 'Beca'.tr,
                  title: 'Return Temp Selection'.tr,
                  value: _mqttController.tempSelectionSwitch.value,
                  onTap: () async {
                    _mqttController.tempselectionSwLoading.value = true;
                    final newValue = !_mqttController.tempSelectionSwitch.value;
                    // await _mqttController.tempSelectSwitch(newValue);
                    _mqttController.tempselectionSwLoading.value = false;
                    return newValue;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_mqttController.circuitAenable.value == true)
                SizedBox(height: Get.height * 0.02),
              if (_mqttController.circuitAenable.value == true)
                GestureDetector(
                  onTap: () {
                    Get.to(() => const CircuitAUserChm());
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
                      'Circuit A'.tr,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              if (_mqttController.circuitBenable.value == true)
                SizedBox(height: Get.height * 0.02),
              if (_mqttController.circuitBenable.value == true)
                GestureDetector(
                  onTap: () {
                    Get.to(() => const CircuitChmB());
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
                      'Circuit B'.tr,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
