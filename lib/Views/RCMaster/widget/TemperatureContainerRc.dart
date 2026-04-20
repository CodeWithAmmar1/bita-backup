import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/RCMaster/widget/Temp_Box_RCM/temperature_RCM.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class Temperaturecontainerrc extends StatelessWidget {
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  Temperaturecontainerrc({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.01),
      child: Container(
        width: Get.width * 0.95,
        padding: EdgeInsets.all(Get.width * 0.03),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          borderRadius: BorderRadius.circular(Get.width * 0.03),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thermostat,
                          color: Colors.red, size: Get.width * 0.07),
                      SizedBox(width: Get.width * 0.015),
                      Text(
                        'systemTempF'.tr,
                        style: TextStyle(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => TemperatureRcm()),
                    child: Icon(
                      Icons.settings,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      size: Get.width * 0.065,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: TemperatureWidgetRC(
                      title: 'suction'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? (_mqttController.rcSucTemp.value == 888.0
                                  ? "888"
                                  : _mqttController.rcSucTemp.value.toString())
                              : "--",
                      getColorLogic: () => (_mqttController.rcSucTemp.value <=
                                  _mqttController.rcSucTempSp.value) ||
                              (_mqttController.rcSucTemp.value == 888.0) ||
                              (_mqttController.rcSucTemp.value == 999.0)
                          ? Colors.red
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: TemperatureWidgetRC(
                      title: 'Super Heat'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? (_mqttController.rcSuper.value == 888.0
                                  ? "888"
                                  : _mqttController.rcSuper.value.toString())
                              : "--",
                      getColorLogic: () =>
                          // (_mqttController
                          //                 .rcSuper.value <=
                          //             _mqttController.rcSuperSp.value) ||
                          (_mqttController.rcSuper.value == 888.0) ||
                                  (_mqttController.rcSuper.value == 999.0)
                              ? Colors.red
                              : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureWidgetRC extends StatelessWidget {
  final String title;
  final String temperature;
  final Color Function()? getColorLogic;

  const TemperatureWidgetRC({
    required this.title,
    required this.temperature,
    super.key,
    this.getColorLogic,
  });

  @override
  Widget build(BuildContext context) {
    final tempColor = getColorLogic != null ? getColorLogic!() : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.015,
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
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.040,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: Get.height * 0.005),
          Text(
            temperature.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.bold,
              color: tempColor,
            ),
          ),
        ],
      ),
    );
  }
}
