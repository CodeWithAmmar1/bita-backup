import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setpoints_screens/chill_water_sp.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Chw extends StatelessWidget {
  final String lefttitle;
  final String righttitle;
  final String deviceid;
  Chw(
      {super.key,
      required this.deviceid,
      required this.lefttitle,
      required this.righttitle});
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
                          lefttitle,
                          // "Supply",
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
                            ? "${_mqttController.dmSupply.value}°C"
                            : "--°C",
                        style: TextStyle(
                          color: _mqttController.dmSupply.value == 888.0
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
                Get.to(() => ChillWaterSp());
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
                              ? "${_mqttController.dmSetpoint.value}°C"
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
                      righttitle, // "Return",
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.04,
                      ),
                    ),
                    Obx(
                      () => Text(
                        _mqttController.deviceConnections[deviceid] ?? false
                            ? "${_mqttController.dmReturn.value}°C"
                            : "--°C",
                        style: TextStyle(
                          color: (_mqttController.dmReturn.value <
                                      _mqttController.dmSetpoint.value ||
                                  _mqttController.dmReturn.value == 888.0)
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
