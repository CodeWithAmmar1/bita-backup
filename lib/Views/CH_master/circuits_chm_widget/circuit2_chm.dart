import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Circuit2Chm extends StatelessWidget {
  final String deviceid;
  Circuit2Chm({super.key, required this.deviceid});
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
                        "CIRCUIT B",
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
                                    ? "${_mqttController.dmSuctionTempB.value}°C"
                                    : "--°C",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: (_mqttController.dmSuctionTempB.value <
                                              _mqttController
                                                  .sucTempspB.value ||
                                          _mqttController
                                                  .dmSuctionTempB.value ==
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
                                    ? "${_mqttController.dmSuctionPressureB.value}PSI"
                                    : "--PSI",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: (_mqttController
                                                  .dmSuctionPressureB.value <
                                              _mqttController
                                                  .sucPressurespB.value ||
                                          _mqttController
                                                  .dmSuctionPressureB.value ==
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
                                    ? "${_mqttController.dmdischargeTempB.value}°C"
                                    : "--°C",
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      (_mqttController.dmdischargeTempB.value >
                                                  _mqttController
                                                      .disTempspB.value ||
                                              _mqttController
                                                      .dmdischargeTempB.value ==
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
                                    ? "${_mqttController.dmdischargePressureB.value}PSI"
                                    : "--PSI",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: (_mqttController
                                                  .dmdischargePressureB.value >
                                              _mqttController
                                                  .disPressurespB.value ||
                                          _mqttController
                                                  .dmdischargePressureB.value ==
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
              //
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
                                    ? "${_mqttController.dmSubCoolingB.value}°C"
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
                                    ? "${_mqttController.dmOilPressureB.value}PSI"
                                    : "--PSI",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: (_mqttController.dmOilPressureB.value <
                                              _mqttController
                                                  .oilPressurespB.value ||
                                          _mqttController
                                                  .dmOilPressureB.value ==
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
                                    ? "${_mqttController.dmSprayB.value}°C"
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
                                    ? "${_mqttController.dmShtB.value}°F"
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
                                    ? "${_mqttController.ampereB.value}A"
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
                            Text(
                              _mqttController.deviceConnections[deviceid] ??
                                      false
                                  ? "${_mqttController.dmRunHoursB.value}"
                                  : "--",
                              style: TextStyle(
                                fontSize: 14,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
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
                                    ? "${_mqttController.dmExvB.value}%"
                                    : "--%",
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
            ],
          ),
        ));
  }
}
