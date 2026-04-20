import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/button/custom_toggle.dart';
import 'package:testappbita/utils/theme/theme.dart';

class HideUnhide extends StatelessWidget {
  final SensorSwitchController controller = Get.put(SensorSwitchController());
  final MqttController _mqttController = Get.find<MqttController>();
  HideUnhide({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = ThemeColor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.actual,
        centerTitle: true,
        title: Text(
          'enableDisableConfig'.tr,
          style: TextStyle(
            fontSize: Get.width * 0.05,
            color: Get.isDarkMode ? themeColor.mode2 : themeColor.mode1,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Obx(
              () => CustomToggle(
                title: 'suctionPressureSwitch'.tr,
                value: _mqttController.showSuctionPressure.value,
                onTap: () async {
                  _mqttController.suctionSwLoadingAm1.value = true;
                  final newValue = !_mqttController.showSuctionPressure.value;
                  await _mqttController.toggleAm1Suction(newValue);
                  _mqttController.suctionSwLoadingAm1.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: "dischargePressureSwitch".tr,
                value: _mqttController.showDischargePressure.value,
                onTap: () async {
                  _mqttController.dischargeSwLoadingAm1.value = true;
                  final newValue = !_mqttController.showDischargePressure.value;
                  await _mqttController.toggleAm1Discharge(newValue);
                  _mqttController.dischargeSwLoadingAm1.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: "oilPressureSwitch".tr,
                value: _mqttController.showOilPressure.value,
                onTap: () async {
                  _mqttController.oilSwLoadingAm1.value = true;
                  final newValue = !_mqttController.showOilPressure.value;
                  await _mqttController.toggleAm1OilPressure(newValue);
                  _mqttController.oilSwLoadingAm1.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(() {
              if (_mqttController.isModeSwitchAm1.value) {
                return CustomToggle(
                  title: "Start/Stop Switch".tr,
                  value: _mqttController.powerSwitchen.value,
                  onTap: () async {
                    _mqttController.swLoadingAm1.value = true;
                    final newValue = !_mqttController.powerSwitchen.value;
                    await _mqttController.toggleAm1Switch(newValue);
                    _mqttController.swLoadingAm1.value = false;
                    return newValue;
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
