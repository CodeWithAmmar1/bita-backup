import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/pressure_configration/pressure_selectiondx.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class PressureSensorconfiguration extends StatelessWidget {
  PressureSensorconfiguration({super.key});
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
                      permission: true,
                      offset: _mqttController.suctionOffsetA,
                      title: 'suction'.tr,
                      pressureUnit: _mqttController.sucPressureUnitA,
                      pressureType: _mqttController.sucPressureTypeA,
                      pressureRange: _mqttController.sucPressureRangeA,
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
                      permission: true,
                      offset: _mqttController.dischargeOffsetA,
                      title: 'discharge'.tr,
                      pressureUnit: _mqttController.disPressureUnitA,
                      pressureType: _mqttController.disPressureTypeA,
                      pressureRange: _mqttController.disPressureRangeA,
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
                  permission: true,
                  offset: _mqttController.oilOffsetA,
                  title: 'oil'.tr,
                  pressureUnit: _mqttController.oilPressureUnitA,
                  pressureType: _mqttController.oilPressureTypeA,
                  pressureRange: _mqttController.oilPressureRangeA,
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
