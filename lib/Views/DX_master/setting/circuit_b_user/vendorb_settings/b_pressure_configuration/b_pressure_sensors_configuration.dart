import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/pressure_configration/pressure_selectiondx.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class BPressureSensorsConfiguration extends StatelessWidget {
  BPressureSensorsConfiguration({super.key});
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
                Get.to(() => PressureSelectiondx(
                      permission: false,
                      offset: _mqttController.suctionOffsetB,
                      title: 'suction'.tr,
                      pressureUnit: _mqttController.sucPressureUnitB,
                      pressureType: _mqttController.sucPressureTypeB,
                      pressureRange: _mqttController.sucPressureRangeB,
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
                Get.to(() => PressureSelectiondx(
                      permission: false,
                      offset: _mqttController.dischargeOffsetB,
                      title: 'discharge'.tr,
                      pressureUnit: _mqttController.disPressureUnitB,
                      pressureType: _mqttController.disPressureTypeB,
                      pressureRange: _mqttController.disPressureRangeB,
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
                Get.to(PressureSelectiondx(
                  permission: false,
                  offset: _mqttController.oilOffsetB,
                  title: 'oil'.tr,
                  pressureUnit: _mqttController.oilPressureUnitB,
                  pressureType: _mqttController.oilPressureTypeB,
                  pressureRange: _mqttController.oilPressureRangeB,
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
