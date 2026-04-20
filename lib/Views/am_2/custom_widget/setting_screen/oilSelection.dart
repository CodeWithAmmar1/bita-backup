import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/button/custom_toggle.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Oilselection extends StatefulWidget {
  const Oilselection({super.key});

  @override
  State<Oilselection> createState() => _OilselectionState();
}

class _OilselectionState extends State<Oilselection> {
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
          'enableDisableConfig'.tr,
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
         Obx(
            () => CustomToggle(
              title: 'suction_pressure_sensor'.tr,
              value: _mqttController.isSuctionPressureVisible.value,
              onTap: () async {
                _mqttController.isSucLoading.value = true;
                final newValue =
                    !_mqttController.isSuctionPressureVisible.value;
                await _mqttController.toggleSucPressure(newValue);
                _mqttController.isSucLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => CustomToggle(
              title: 'discharge_pressure_sensor'.tr,
              value: _mqttController.isDischargePressureVisible.value,
              onTap: () async {
                _mqttController.isDisLoading.value = true;
                final newValue =
                    !_mqttController.isDischargePressureVisible.value;
                await _mqttController.toggleDisPressure(newValue);
                _mqttController.isDisLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),  Obx(
            () => CustomToggle(
              title: 'oilPressureSensor'.tr,
              value: _mqttController.isOilPressureVisible.value,
              onTap: () async {
                _mqttController.isOilLoading.value = true;
                final newValue = !_mqttController.isOilPressureVisible.value;
                await _mqttController.toggleOilPressure(newValue);
                _mqttController.isOilLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
         
          Obx(
            () => CustomToggle(
              title: 'oilPressureSwitch'.tr,
              value: _mqttController.isSwitchBoxVisible.value,
              onTap: () async {
                _mqttController.oilSwLoading.value = true;
                final newValue = !_mqttController.isSwitchBoxVisible.value;
                await _mqttController.toggleSwitchBox(newValue);
                _mqttController.oilSwLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => CustomToggle(
              title: 'suctionPressureSwitch'.tr,
              value: _mqttController.isSuctionSwitchVisible.value,
              onTap: () async {
                _mqttController.suctionSwLoading.value = true;
                final newValue = !_mqttController.isSuctionSwitchVisible.value;
                await _mqttController.toggleSuctionSwitch(newValue);
                _mqttController.suctionSwLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => CustomToggle(
              title: 'dischargePressureSwitch'.tr,
              value: _mqttController.isDischargeSwitchVisible.value,
              onTap: () async {
                _mqttController.dischargeSwLoading.value = true;
                final newValue =
                    !_mqttController.isDischargeSwitchVisible.value;
                await _mqttController.toggleDischargeSwitch(newValue);
                _mqttController.dischargeSwLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => CustomToggle(
              title: 'ampere_switch'.tr,
              value: _mqttController.isAmpVisible.value,
              onTap: () async {
                _mqttController.isAmpLoading.value = true;
                final newValue = !_mqttController.isAmpVisible.value;
                await _mqttController.toggleAmp(newValue);
                _mqttController.isAmpLoading.value = false;
                return newValue;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
