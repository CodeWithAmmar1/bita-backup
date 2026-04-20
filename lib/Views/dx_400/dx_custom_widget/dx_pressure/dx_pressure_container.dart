import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_pressure/dx_pressure.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class DxPressureContainer extends StatelessWidget {
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  DxPressureContainer({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    final boxWidth = Get.width * 0.95;
    return Obx(() {
      if (!(_mqttController.dxisOilPressureVisible.value ||
              _mqttController.dxisDischargePressureVisible.value ||
              _mqttController.dxisSuctionPressureVisible.value
          // ||
          // _mqttController.dxisFbVisible.value ||
          // _mqttController.dxisInnerVisible.value ||
          // _mqttController.dxisCompVisible.value
          )) {
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
                          _mqttController.dxpsiTobar.toggle();
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.buildJsonPayloadDXPressure();
                            _mqttController.isUserInteracting.value = false;
                          });
                        },
                        child: Obx(
                          () => Text(
                            _mqttController.dxpsiTobar.value
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
                    onTap: () => Get.to(() => DxPressure()),
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

                if (_mqttController.dxisSuctionPressureVisible.value) {
                  indicators.add(
                    Expanded(
                      child: DxPressureHomeWidget(
                        title: "suction".tr,
                        pressure: _mqttController.deviceConnections[deviceId] ==
                                true
                            ? _mqttController.dxpsiTobar.value
                                ? (_mqttController.dxpsig1.value == 999
                                    ? "None"
                                    : _mqttController.dxpsig1.value.toString())
                                : (_mqttController.dxpsig1F.value == 999
                                    ? "None"
                                    : _mqttController.dxpsig1F.value.toString())
                            : "--",
                        userSetLow: _mqttController.dxpsig1.value,
                        getColorLogic: (pressure) =>
                            _mqttController.dxpsig1.value <=
                                    _mqttController.dxpsig1sethigh.value
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                      ),
                    ),
                  );
                }

                if (_mqttController.dxisDischargePressureVisible.value) {
                  indicators.addAll([
                    if (indicators.isNotEmpty)
                      SizedBox(width: Get.width * 0.015),
                    Expanded(
                      child: DxPressureHomeWidget(
                        title: "discharge".tr,
                        pressure: _mqttController.deviceConnections[deviceId] ==
                                true
                            ? _mqttController.dxpsiTobar.value
                                ? (_mqttController.dxpsig2.value == 999
                                    ? "None"
                                    : _mqttController.dxpsig2.value.toString())
                                : (_mqttController.dxpsig2F.value == 999
                                    ? "None"
                                    : _mqttController.dxpsig2F.value.toString())
                            : "--",
                        userSetLow: _mqttController.dxpsig2.value,
                        getColorLogic: (pressure) =>
                            _mqttController.dxpsig2.value >=
                                    _mqttController.dxpsig2setlow.value
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                      ),
                    ),
                  ]);
                }

                if (_mqttController.dxisOilPressureVisible.value) {
                  indicators.addAll([
                    if (indicators.isNotEmpty)
                      SizedBox(width: Get.width * 0.015),
                    Expanded(
                      child: DxPressureHomeWidget(
                        title: "oil".tr,
                        pressure: _mqttController.deviceConnections[deviceId] ==
                                true
                            ? _mqttController.dxpsiTobar.value
                                ? (_mqttController.dxpsig3.value == 999
                                    ? "None"
                                    : _mqttController.dxpsig3.value.toString())
                                : (_mqttController.dxpsig3F.value == 999
                                    ? "None"
                                    : _mqttController.dxpsig3F.value.toString())
                            : "--",
                        userSetLow: _mqttController.dxpsig3.value,
                        getColorLogic: (pressure) =>
                            _mqttController.dxpsig3.value <=
                                    _mqttController.dxpsig3sethigh.value
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

class DxPressureHomeWidget extends StatelessWidget {
  final String title;
  final String pressure;
  final double userSetLow;
  final Color Function(String pressure)? getColorLogic;

  const DxPressureHomeWidget({
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
