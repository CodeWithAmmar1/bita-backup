import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/RCMaster/widget/pressures/pressure_box/pressure_rcm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class PressureContainerRcm extends StatelessWidget {
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  PressureContainerRcm({super.key, required this.deviceId});
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
                    Text(
                      'System Pressure (PSI)'.tr,
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.to(() => PressureRcm()),
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
                    child: PressureHomeWidgetRCM(
                      title: "suction".tr,
                      pressure:
                          _mqttController.deviceConnections[deviceId] == true
                              ? (_mqttController.rcSucpre.value == 888
                                  ? "888"
                                  : _mqttController.rcSucpre.value.toString())
                              : "--",
                      getColorLogic: (pressure) =>
                          (_mqttController.rcSucpre.value <=
                                      _mqttController.rcSucpreSp.value) ||
                                  (_mqttController.rcSucpre.value == 888) ||
                                  (_mqttController.rcSucpre.value == 999)
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

class PressureHomeWidgetRCM extends StatelessWidget {
  final String title;
  final String pressure;
  final Color Function(String pressure)? getColorLogic;

  const PressureHomeWidgetRCM({
    required this.title,
    required this.pressure,
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
