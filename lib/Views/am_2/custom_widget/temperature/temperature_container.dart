import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperature.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class TemperatureContainer extends StatelessWidget {
  final RxBool isReturn = true.obs;
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  TemperatureContainer({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.02),
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
                      GestureDetector(
                          onTap: () {
                            _mqttController.isUserInteracting.value = true;
                            _mqttController.ftoC.toggle();
                            publishTimer?.cancel();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.buildJsonPayloadPressure();
                              log("Temperature: ${_mqttController.ftoC.value}");
                              _mqttController.isUserInteracting.value = false;
                            });
                          },
                          child: Obx(() => Text(
                                _mqttController.ftoC.value
                                    ? 'systemTempC'.tr
                                    : 'systemTempF'.tr,
                                style: TextStyle(
                                  fontSize: Get.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ))),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => Temperature()),
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
                    child: Obx(() => GestureDetector(
                          onTap: () => isReturn.toggle(),
                          child: TemperatureWidget(
                            title: isReturn.value ? 'return'.tr : 'supply'.tr,
                            temperature: _mqttController
                                        .deviceConnections[deviceId] ??
                                    false
                                ? isReturn.value
                                    ? _mqttController.temp1.value == 999.9
                                        ? "None"
                                        : _mqttController.temp1.value.toString()
                                    : _mqttController.temp2.value == 999.9
                                        ? "None"
                                        : _mqttController.temp2.value.toString()
                                : "--",
                            getColorLogic: () {
                              if (isReturn.value) {
                                return (_mqttController.temp1setlow.value <=
                                            _mqttController.temp1.value) ||
                                        (_mqttController.temp1.value == 888.00)
                                    ? Colors.red
                                    : Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black;
                              } else {
                                return _mqttController.temp2.value == 888.00
                                    ? Colors.red
                                    : Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black;
                              }
                            },
                          ),
                        )),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: TemperatureWidget(
                      title: 'suction'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? _mqttController.temp3.value == 999.9
                                  ? "None"
                                  : _mqttController.temp3.value.toString()
                              : "--",
                      getColorLogic: () => _mqttController.temp3.value <=
                                  _mqttController.temp3sethigh.value ||
                              (_mqttController.temp3.value == 888.00)
                          ? Colors.red
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: TemperatureWidget(
                      title: 'discharge'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? _mqttController.temp4.value == 999.9
                                  ? "None"
                                  : _mqttController.temp4.value.toString()
                              : "--",
                      getColorLogic: () => _mqttController.temp4.value >=
                                  _mqttController.temp4setlow.value ||
                              (_mqttController.temp4.value == 888.00)
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

class TemperatureWidget extends StatelessWidget {
  final String title;
  final String temperature;
  final Color Function()? getColorLogic;

  const TemperatureWidget({
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
