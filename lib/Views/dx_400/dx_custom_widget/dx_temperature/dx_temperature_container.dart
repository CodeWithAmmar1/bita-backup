import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperature.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class DxTemperatureContainer extends StatelessWidget {
  final RxBool isReturn = true.obs;
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  DxTemperatureContainer({super.key, required this.deviceId});
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
                            _mqttController.dxftoC.toggle();
                            publishTimer?.cancel();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.buildJsonPayloadDXPressure();
                              log("Temperature: ${_mqttController.dxftoC.value}");
                              _mqttController.isUserInteracting.value = false;
                            });
                          },
                          child: Obx(() => Text(
                                _mqttController.dxftoC.value
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
                    onTap: () => Get.to(() => DxTemperature()),
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
                          child: DXTemperatureWidget(
                            title: isReturn.value ? 'return'.tr : 'supply'.tr,
                            temperature: _mqttController
                                        .deviceConnections[deviceId] ??
                                    false
                                ? isReturn.value
                                    ? _mqttController.dxftoC.value
                                        ? _mqttController.dxtemp1.value == 999.9
                                            ? "None"
                                            : _mqttController.dxtemp1.value
                                                .toString()
                                        : _mqttController.dxtemp1F.value == 999.9
                                            ? "None"
                                            : _mqttController.dxtemp1F.value
                                                .toString()
                                    : _mqttController.dxftoC.value
                                        ? _mqttController.dxtemp2.value == 999.9
                                            ? "None"
                                            : _mqttController.dxtemp2.value
                                                .toString()
                                        : _mqttController.dxtemp2F.value == 999.9
                                            ? "None"
                                            : _mqttController.dxtemp2F.value
                                                .toString()
                                : "--",
                            getColorLogic: () {
                              if (isReturn.value) {
                                return (_mqttController.dxtemp1setlow.value <=
                                        _mqttController.dxtemp1.value)
                                    ? Colors.red
                                    : Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black;
                              } else {
                                return Get.isDarkMode
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
                    child: DXTemperatureWidget(
                      title: 'suction'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? _mqttController.dxftoC.value
                                  ? _mqttController.dxtemp3.value == 999.9
                                      ? "None"
                                      : _mqttController.dxtemp3.value.toString()
                                  : _mqttController.dxtemp3F.value == 999.9
                                      ? "None"
                                      : _mqttController.dxtemp3F.value.toString()
                              : "--",
                      getColorLogic: () => _mqttController.dxtemp3.value <=
                              _mqttController.dxtemp3sethigh.value
                          ? Colors.red
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: DXTemperatureWidget(
                      title: 'discharge'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? _mqttController.dxftoC.value
                                  ? _mqttController.dxtemp4.value == 999.9
                                      ? "None"
                                      : _mqttController.dxtemp4.value.toString()
                                  : _mqttController.dxtemp4F.value == 999.9
                                      ? "None"
                                      : _mqttController.dxtemp4F.value.toString()
                              : "--",
                      getColorLogic: () => _mqttController.dxtemp4.value >=
                              _mqttController.dxtemp4setlow.value
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

class DXTemperatureWidget extends StatelessWidget {
  final String title;
  final String temperature;
  final Color Function()? getColorLogic;

  DXTemperatureWidget({
    required this.title,
    required this.temperature,
    Key? key,
    this.getColorLogic,
  }) : super(key: key);

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
