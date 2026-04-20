import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_setting_screen/dx_pressure_setting/dx_pressureSelection.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxPressureSettingPage extends StatelessWidget {
  DxPressureSettingPage({super.key});
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
                Get.to(DxPressureselection(
                  title: 'suction'.tr,
                  pressureUnit: _mqttController.dxpressureUnit,
                  pressureType: _mqttController.dxpressureType,
                  pressureRange: _mqttController.dxpressureRange,
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
                  'suctionPressureSensors'.tr,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            GestureDetector(
              onTap: () {
                Get.to(DxPressureselection(
                  title: 'discharge'.tr,
                  pressureUnit: _mqttController.dxpressureUnit2,
                  pressureType: _mqttController.dxpressureType2,
                  pressureRange: _mqttController.dxpressureRange2,
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
                  'dischargePressureSensors'.tr,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            GestureDetector(
              onTap: () {
                Get.to(DxPressureselection(
                  title: 'oil'.tr,
                  pressureUnit: _mqttController.dxpressureUnit3,
                  pressureType: _mqttController.dxpressureType3,
                  pressureRange: _mqttController.dxpressureRange3,
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
                  'oilPressureSensors'.tr,
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
