import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Circuitchm extends StatelessWidget {
  final String deviceid;
  Circuitchm({super.key, required this.deviceid});
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Container(
          width: Get.width * 0.95,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width * 0.8,
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? ThemeColor().mode2
                            : ThemeColor().mode1,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "CIRCUIT A",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: baseSize * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Suction",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.chmSuctionTempA.value}°C"
                                      : "--°C",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        (_mqttController.chmSuctionTempA.value <
                                                    _mqttController
                                                        .chmsucTempspA.value ||
                                                _mqttController
                                                        .chmSuctionTempA.value ==
                                                    888.0)
                                            ? Colors.redAccent
                                            : Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Suction",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmSuctionPressureA.value}PSI"
                                      : "--PSI",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (_mqttController
                                                    .dmSuctionPressureA.value <
                                                _mqttController
                                                    .sucPressurespA.value ||
                                            _mqttController
                                                    .dmSuctionPressureA.value ==
                                                888)
                                        ? Colors.redAccent
                                        : Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Discharge",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmdischargeTempA.value}°C"
                                      : "--°C",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (_mqttController
                                                    .dmdischargeTempA.value >
                                                _mqttController
                                                    .disTempspA.value ||
                                            _mqttController
                                                    .dmdischargeTempA.value ==
                                                888.0)
                                        ? Colors.redAccent
                                        : Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Discharge",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmdischargePressureA.value}PSI"
                                      : "--PSI",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (_mqttController.dmdischargePressureA
                                                    .value >
                                                _mqttController
                                                    .disPressurespA.value ||
                                            _mqttController
                                                    .dmdischargeTempA.value ==
                                                888)
                                        ? Colors.redAccent
                                        : Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sub Cooling",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmSubCoolingA.value}°C"
                                      : "--°C",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Oil",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmOilPressureA.value}PSI"
                                      : "--PSI",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        (_mqttController.dmOilPressureA.value <
                                                    _mqttController
                                                        .oilPressurespA.value ||
                                                _mqttController
                                                        .dmOilPressureA.value ==
                                                    888)
                                            ? Colors.redAccent
                                            : Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Spray",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmSprayA.value}°C"
                                      : "--°C",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "SHT",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmShtA.value}°F"
                                      : "--°F",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Comp Amp",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.ampereA.value}A"
                                      : "--A",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Run Hrs",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmRunHoursA.value}"
                                      : "--",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: baseSize * 0.2,
                        height: baseSize * 0.05,
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2
                                : ThemeColor().mode1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "EXV",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  _mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? "${_mqttController.dmExvA.value}%"
                                      : "--%",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (_mqttController.dmExvA.value > 0 &&
                                            _mqttController.dmExvA.value < 100)
                                        ? (Get.isDarkMode
                                            ? Colors.lightBlueAccent
                                            : Colors.blueAccent)
                                        : Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
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
              ],
            ),
          ),
        ));
  }
}
