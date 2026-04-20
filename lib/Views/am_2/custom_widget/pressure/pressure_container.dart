import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressure.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class PressureContainer extends StatelessWidget {
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  PressureContainer({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    final boxWidth = Get.width * 0.95;

    return Obx(() {
      if (!(_mqttController.isOilPressureVisible.value ||
          _mqttController.isDischargePressureVisible.value ||
          _mqttController.isSuctionPressureVisible.value)) {
        return SizedBox();
      }

      return Padding(
        padding: EdgeInsets.all(Get.width * 0.02),
        child: Container(
          width: boxWidth,
          padding: EdgeInsets.all(Get.width * 0.03),
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed,
                          color: Colors.red, size: Get.width * 0.07),
                      SizedBox(width: Get.width * 0.015),
                      GestureDetector(
                        onTap: () {
                          _mqttController.isUserInteracting.value = true;
                          _mqttController.psiTobar.toggle();
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.buildJsonPayloadPressure();
                            _mqttController.isUserInteracting.value = false;
                          });
                        },
                        child: Obx(
                          () => Text(
                            _mqttController.psiTobar.value
                                ? 'systemPressurePsi'.tr
                                : 'systemPressureBar'.tr,
                            style: TextStyle(
                              fontSize: Get.width * 0.045,
                              fontWeight: FontWeight.bold,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => Pressures()),
                    child: Icon(
                      Icons.settings,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      size: Get.width * 0.065,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(() {
                final indicators = <Widget>[];

                if (_mqttController.isSuctionPressureVisible.value) {
                  indicators.add(
                    Expanded(
                      child: PressureHomeWidget(
                        title: "suction".tr,
                        pressure:
                            _mqttController.deviceConnections[deviceId] == true
                                ? (_mqttController.psig1.value == 999
                                    ? "None"
                                    : _mqttController.psig1.value.toString())
                                : "--",
                        userSetLow: _mqttController.psig1.value,
                        getColorLogic: (pressure) =>
                            _mqttController.psig1.value <=
                                        _mqttController.psig1sethigh.value ||
                                    (_mqttController.psig1.value == 888.00)
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                      ),
                    ),
                  );
                }
                if (_mqttController.isDischargePressureVisible.value) {
                  indicators.addAll([
                    if (indicators.isNotEmpty)
                      SizedBox(width: Get.width * 0.015),
                    Expanded(
                      child: PressureHomeWidget(
                        title: "discharge".tr,
                        pressure:
                            _mqttController.deviceConnections[deviceId] == true
                                ? (_mqttController.psig2.value == 999
                                    ? "None"
                                    : _mqttController.psig2.value.toString())
                                : "--",
                        userSetLow: _mqttController.psig2.value,
                        getColorLogic: (pressure) =>
                            _mqttController.psig2.value >=
                                        _mqttController.psig2setlow.value ||
                                    (_mqttController.psig2.value == 888.00)
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                      ),
                    ),
                  ]);
                }
                if (_mqttController.isOilPressureVisible.value) {
                  indicators.addAll([
                    if (indicators.isNotEmpty)
                      SizedBox(width: Get.width * 0.015),
                    Expanded(
                      child: PressureHomeWidget(
                        title: "oil".tr,
                        pressure:
                            _mqttController.deviceConnections[deviceId] == true
                                ? (_mqttController.psig3.value == 999
                                    ? "None"
                                    : _mqttController.psig3.value.toString())
                                : "--",
                        userSetLow: _mqttController.psig3.value,
                        getColorLogic: (pressure) =>
                            _mqttController.psig3.value <=
                                        _mqttController.psig3sethigh.value ||
                                    (_mqttController.psig3.value == 888.00)
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
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
}

class PressureHomeWidget extends StatelessWidget {
  final String title;
  final String pressure;
  final double userSetLow;
  final Color Function(String pressure)? getColorLogic;

  const PressureHomeWidget({
    required this.title,
    required this.pressure,
    required this.userSetLow,
    this.getColorLogic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final psi = pressure;
    final pressureColor =
        getColorLogic != null ? getColorLogic!(psi) : Colors.white;

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
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.040,
              // fontSize: Get.width * 0.035,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: Get.height * 0.005),
          Text(
            pressure.contains('.') ? pressure.split('.')[0] : pressure,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.042,
              fontWeight: FontWeight.bold,
              color: pressureColor,
            ),
          ),
        ],
      ),
    );
  }
}
