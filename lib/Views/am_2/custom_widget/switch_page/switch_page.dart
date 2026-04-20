import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SwitchPage extends StatelessWidget {
  final String deviceId;
  SwitchPage({super.key, required this.deviceId});

  final SensorSwitchController controller = Get.put(SensorSwitchController());
  final MqttController _mqttController = Get.put(MqttController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Obx(() {
      if (!(_mqttController.isSwitchBoxVisible.value ||
          _mqttController.isSuctionSwitchVisible.value ||
          _mqttController.isDischargeSwitchVisible.value)) {
        return SizedBox();
      }

      return Padding(
        padding: EdgeInsets.all(Get.width * 0.02),
        child: Container(
          width: Get.width * 0.95,
          padding: EdgeInsets.all(Get.width * 0.03),
          decoration: BoxDecoration(
            color: isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.speed, color: Colors.red, size: Get.width * 0.07),
                  SizedBox(width: Get.width * 0.015),
                  Text(
                     'pressureSwitches'.tr,
                    style: TextStyle(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.015),
              Obx(() {
                final indicators = <Widget>[];

                if (_mqttController.isSuctionSwitchVisible.value) {
                  indicators.add(
                    Expanded(
                      child: _buildIndicatorTile(
                        label: 'suction'.tr,
                        alert:
                             _mqttController.deviceConnections[deviceId] ??
                                        false
                                    ? 
                                     _mqttController.lowpreswam2.value == "LOW"
                                        ? 'low'.tr
                                        : 'ok'.tr : "--",
                        alertColor: _mqttController.lowpreswam2.value == 'LOW'
                            ? Colors.red
                            : textColor,
                        isActive: _mqttController.lowpreswam2.value == 'HIGH',
                        textColor: textColor,
                      ),
                    ),
                  );
                }

                if (_mqttController.isDischargeSwitchVisible.value) {
                  indicators.addAll([
                    if (indicators.isNotEmpty)
                      SizedBox(width: Get.width * 0.015),
                    Expanded(
                      child: _buildIndicatorTile(
                        label: 'discharge'.tr,
                        alert:
                            _mqttController.deviceConnections[deviceId] ?? false
                                ? 
                                _mqttController.highpreswam2.value == "HIGH"
                                    ? 'high'.tr
                                    : 'ok'.tr : "--",
                        alertColor: _mqttController.highpreswam2.value == 'HIGH'
                            ? Colors.red
                            : textColor,
                        isActive: _mqttController.highpreswam2.value == 'HIGH',
                        textColor: textColor,
                      ),
                    ),
                  ]);
                }

                if (_mqttController.isSwitchBoxVisible.value) {
                  indicators.addAll([
                    if (indicators.isNotEmpty)
                      SizedBox(width: Get.width * 0.015),
                    Expanded(
                      child: _buildIndicatorTile(
                        label: 'oil'.tr,
                        alert: _mqttController.deviceConnections[deviceId] ??
                                false
                            ?
                             _mqttController.oilpressureswam2.value == "LOW"
                                ? 'low'.tr
                                : 'ok'.tr : "--",
                        alertColor:
                            _mqttController.oilpressureswam2.value == 'LOW'
                                ? Colors.red
                                : textColor,
                        isActive:
                            _mqttController.oilpressureswam2.value == 'LOW',
                        textColor: textColor,
                      ),
                    ),
                  ]);
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: indicators,
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildIndicatorTile({
    required String label,
    required bool isActive,
    required Color textColor,
    required Color alertColor,
    required String alert,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.012,
        horizontal: Get.width * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.width * 0.02),
        color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.040,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: Get.height * 0.005),
          Text(
            alert,
            style: TextStyle(
              color: alertColor,
              fontSize: Get.width * 0.042,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
