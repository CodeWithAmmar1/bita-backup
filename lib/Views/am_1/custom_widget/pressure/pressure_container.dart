import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/pressure/pressure.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class PressureContainerAm1 extends StatelessWidget {
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  PressureContainerAm1({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    final boxWidth = Get.width * 0.95;

    return Padding(
      padding: EdgeInsets.all(Get.width * 0.01),
      child: Container(
        width: boxWidth,
        padding: EdgeInsets.all(Get.width * 0.03),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
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
                        _mqttController.psiTobar1.toggle();
                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.buildJsonPayloadAm1Sensor();
                          _mqttController.isUserInteracting.value = false;
                        });
                      },
                      child: Obx(
                        () => Text(
                          _mqttController.psiTobar1.value
                              ? 'system_pressures_psi'.tr
                              : 'system_pressures_bar'.tr,
                          style: TextStyle(
                            fontSize: Get.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.to(() => PressuresAm1()),
                  child: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: Get.width * 0.065,
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: PressureHomeWidgetAm1(
                      title: "suction".tr,
                      pressure: _mqttController.deviceConnections[deviceId] ==
                              true
                          ? _mqttController.psiTobar1.value
                              ? (_mqttController.suctionpressure.value == 888.0
                                  ? "888"
                                  : _mqttController.suctionpressure.value
                                      .toString())
                              : (_mqttController.suctionpressureF.value == 888.0
                                  ? "888"
                                  : _mqttController.suctionpressureF.value
                                      .toString())
                          : "--",
                      userSetLow: _mqttController.suctionpressure.value,
                      getColorLogic: (pressure) => (_mqttController
                                      .suctionpressure.value <=
                                  _mqttController.pressuresp1.value) ||
                              (_mqttController.suctionpressure.value ==
                                  888.0) ||
                              (_mqttController.suctionpressureF.value ==
                                  888.0) ||
                              (_mqttController.suctionpressure.value ==
                                  999.0) ||
                              (_mqttController.suctionpressureF.value == 999.0)
                          ? Colors.red
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: PressureHomeWidgetAm1(
                      title: "discharge".tr,
                      pressure:
                          _mqttController.deviceConnections[deviceId] == true
                              ? _mqttController.psiTobar1.value
                                  ? (_mqttController.dischargepressure.value ==
                                          888.0
                                      ? "888"
                                      : _mqttController.dischargepressure.value
                                          .toString())
                                  : (_mqttController.dischargepressureF.value ==
                                          888.0
                                      ? "888"
                                      : _mqttController.dischargepressureF.value
                                          .toString())
                              : "--",
                      userSetLow: _mqttController.dischargepressure.value,
                      getColorLogic: (pressure) => (_mqttController
                                      .dischargepressure.value >=
                                  _mqttController.pressuresp2.value) ||
                              (_mqttController.dischargepressure.value ==
                                  888.0) ||
                              (_mqttController.dischargepressureF.value ==
                                  888.0) ||
                              (_mqttController.dischargepressureF.value ==
                                  999.0) ||
                              (_mqttController.dischargepressure.value == 999.0)
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

class PressureHomeWidgetAm1 extends StatelessWidget {
  final String title;
  final String pressure;
  final double userSetLow;
  final Color Function(String pressure)? getColorLogic;

  PressureHomeWidgetAm1({
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
