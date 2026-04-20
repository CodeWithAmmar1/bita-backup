import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/pressure_setting/pressureSelection.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class PressureSettingPage extends StatelessWidget {
  PressureSettingPage({super.key});
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'pressureSensorsConfig'.tr,
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.02),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.to(Pressureselection(
                  title: 'suction'.tr,
                  pressureUnit: _mqttController.pressureUnit,
                  pressureType: _mqttController.pressureType,
                  pressureRange: _mqttController.pressureRange,
                ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: textColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textColor,
                  size: 20,
                ),
                title: Text(
                  'suctionPressureSensor'.tr,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            GestureDetector(
              onTap: () {
                Get.to(Pressureselection(
                  title: 'discharge'.tr,
                  pressureUnit: _mqttController.pressureUnit2,
                  pressureType: _mqttController.pressureType2,
                  pressureRange: _mqttController.pressureRange2,
                ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: textColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textColor,
                  size: 20,
                ),
                title: Text(
                  'dischargePressureSensor'.tr,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            GestureDetector(
              onTap: () {
                Get.to(Pressureselection(
                  title: 'oil'.tr,
                  pressureUnit: _mqttController.pressureUnit3,
                  pressureType: _mqttController.pressureType3,
                  pressureRange: _mqttController.pressureRange3,
                ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: textColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textColor,
                  size: 20,
                ),
                title: Text(
                  'oilPressureSensor'.tr,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
