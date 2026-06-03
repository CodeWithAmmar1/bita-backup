import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setpoints_screens_chm/chill_water_sp_chm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class ChwMaster extends StatelessWidget {
  final String deviceid;
  ChwMaster({super.key, required this.deviceid});
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.01, vertical: Get.width * 0.005),
      child: Container(
        width: Get.width * 0.95,
        padding: EdgeInsets.all(Get.width * 0.03),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          borderRadius: BorderRadius.circular(Get.width * 0.03),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: baseSize * 0.08,
              width: baseSize * 0.13,
              decoration: BoxDecoration(
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "CHW IN",
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Text(
                        _mqttController.deviceConnections[deviceid] ?? false
                            ? "${_mqttController.chmSupply.value}°C"
                            : "--°C",
                        style: TextStyle(
                          color: _mqttController.chmSupply.value == 888.0
                              ? Colors.redAccent
                              : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: Get.width * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ChillWaterSpChm());
              },
              child: Container(
                height: baseSize * 0.08,
                width: baseSize * 0.14,
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? ThemeColor().mode2
                        : ThemeColor().mode1,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Set Point",
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Get.width * 0.04,
                        ),
                      ),
                      Obx(
                        () => Text(
                          _mqttController.deviceConnections[deviceid] ?? false
                              ? "${_mqttController.chmSetpoint.value}°C"
                              : "--°C",
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: baseSize * 0.08,
              width: baseSize * 0.13,
              decoration: BoxDecoration(
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CHW OUT",
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.04,
                      ),
                    ),
                    Obx(
                      () => Text(
                        _mqttController.deviceConnections[deviceid] ?? false
                            ? "${_mqttController.chmReturn.value}°C"
                            : "--°C",
                        style: TextStyle(
                          color: (_mqttController.chmReturn.value <
                                      _mqttController.chmSetpoint.value ||
                                  _mqttController.chmReturn.value == 888.0)
                              ? Colors.redAccent
                              : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: Get.width * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
