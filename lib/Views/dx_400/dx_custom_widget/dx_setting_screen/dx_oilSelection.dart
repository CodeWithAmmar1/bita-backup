import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/button/custom_toggle.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxOilselection extends StatefulWidget {
  const DxOilselection({super.key});

  @override
  State<DxOilselection> createState() => _DxOilselectionState();
}

class _DxOilselectionState extends State<DxOilselection> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Obx(
              () => CustomToggle(
                title: 'suction_pressure_sensor'.tr,
                value: _mqttController.dxisSuctionPressureVisible.value,
                onTap: () async {
                  _mqttController.dxisSucLoading.value = true;
                  final newValue =
                      !_mqttController.dxisSuctionPressureVisible.value;
                  await _mqttController.dxtoggleSucPressure(newValue);
                  _mqttController.dxisSucLoading.value = false;
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
                value: _mqttController.dxisDischargePressureVisible.value,
                onTap: () async {
                  _mqttController.dxisDisLoading.value = true;
                  final newValue =
                      !_mqttController.dxisDischargePressureVisible.value;
                  await _mqttController.dxtoggleDisPressure(newValue);
                  _mqttController.dxisDisLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: 'oilPressureSensor'.tr,
                value: _mqttController.dxisOilPressureVisible.value,
                onTap: () async {
                  _mqttController.dxisOilLoading.value = true;
                  final newValue =
                      !_mqttController.dxisOilPressureVisible.value;
                  await _mqttController.dxtoggleOilPressure(newValue);
                  _mqttController.dxisOilLoading.value = false;
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
                value: _mqttController.dxisSwitchBoxVisible.value,
                onTap: () async {
                  _mqttController.dxoilSwLoading.value = true;
                  final newValue = !_mqttController.dxisSwitchBoxVisible.value;
                  await _mqttController.dxtoggleSwitchBox(newValue);
                  _mqttController.dxoilSwLoading.value = false;
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
                value: _mqttController.dxisSuctionSwitchVisible.value,
                onTap: () async {
                  _mqttController.dxsuctionSwLoading.value = true;
                  final newValue =
                      !_mqttController.dxisSuctionSwitchVisible.value;
                  await _mqttController.dxtoggleSuctionSwitch(newValue);
                  _mqttController.dxsuctionSwLoading.value = false;
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
                value: _mqttController.dxisDischargeSwitchVisible.value,
                onTap: () async {
                  _mqttController.dxdischargeSwLoading.value = true;
                  final newValue =
                      !_mqttController.dxisDischargeSwitchVisible.value;
                  await _mqttController.dxtoggleDischargeSwitch(newValue);
                  _mqttController.dxdischargeSwLoading.value = false;
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
                value: _mqttController.dxisAmpVisible.value,
                onTap: () async {
                  _mqttController.dxisAmpLoading.value = true;
                  final newValue = !_mqttController.dxisAmpVisible.value;
                  await _mqttController.dxtoggleAmp(newValue);
                  _mqttController.dxisAmpLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: 'comp_overload'.tr,
                value: _mqttController.dxisCompVisible.value,
                onTap: () async {
                  _mqttController.dxisCompLoading.value = true;
                  final newValue = !_mqttController.dxisCompVisible.value;
                  await _mqttController.dxtoggleComp(newValue);
                  _mqttController.dxisCompLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: 'condenser_overload'.tr,
                value: _mqttController.dxisFbVisible.value,
                onTap: () async {
                  _mqttController.dxisFbLoading.value = true;
                  final newValue = !_mqttController.dxisFbVisible.value;
                  await _mqttController.dxtoggleFb(newValue);
                  _mqttController.dxisFbLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: 'compressor_feedback'.tr,
                value: _mqttController.dxisCompFbVisible.value,
                onTap: () async {
                  _mqttController.dxiscompfbLoading.value = true;
                  final newValue = !_mqttController.dxisCompFbVisible.value;
                  await _mqttController.dxtogglecompfb(newValue);
                  _mqttController.dxiscompfbLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: 'inner_fan_feedback'.tr,
                value: _mqttController.dxisInnerVisible.value,
                onTap: () async {
                  _mqttController.dxisInnerLoading.value = true;
                  final newValue = !_mqttController.dxisInnerVisible.value;
                  await _mqttController.dxtoggleInner(newValue);
                  _mqttController.dxisInnerLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomToggle(
                title: 'heater_fan_feedback'.tr,
                value: _mqttController.dxisHeatVisible.value,
                onTap: () async {
                  _mqttController.dxisHeatLoading.value = true;
                  final newValue = !_mqttController.dxisHeatVisible.value;
                  await _mqttController.dxtoggleHeat(newValue);
                  _mqttController.dxisHeatLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
