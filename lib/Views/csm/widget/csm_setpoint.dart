import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CsmSetpoint extends StatelessWidget {
  final String deviceid;
  CsmSetpoint({
    super.key,
    required this.deviceid,
  });
  final MqttController mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    Timer? publishTimer;
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        title: Text(
          "Set Point",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Obx(
              () => SleekCircularSlider(
                appearance: CircularSliderAppearance(
                  size: baseSize * 0.3,
                  angleRange: 260,
                  startAngle: 140,
                  customWidths: CustomSliderWidths(
                    trackWidth: baseSize * 0.004,
                    progressBarWidth: baseSize * 0.004,
                    handlerSize: baseSize * 0.012,
                  ),
                  customColors: CustomSliderColors(
                    trackColor: Colors.grey[500],
                    progressBarColors: [Color(0xFF24C48E), Color(0xFF24C456)],
                    dotColor: Color(0xFF24C48E),
                  ),
                ),
                min: 0,
                max: 40,
                initialValue:
                    mqttController.tempcsmSp.value.toDouble().clamp(0, 40),
                onChangeStart: (_) {
                  mqttController.isUserInteracting.value = true;
                },
                onChange: (double value) {
                  mqttController.isUserInteracting.value = true;
                  mqttController.tempcsmSp.value = value.toInt();
                },
                onChangeEnd: (double value) {
                  publishTimer?.cancel();
                  publishTimer = Timer(Duration(seconds: 1), () {
                    mqttController.updateSetpointcsm(value);
                    mqttController.isUserInteracting.value = false;
                  });
                },
              ),
            ),
            Container(
              width: shortestSide * 0.53,
              height: baseSize * 0.3,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? ThemeColor().mode2Sec
                    : ThemeColor().mode1Sec,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Get.isDarkMode
                        ? ThemeColor().actual.withValues(alpha: 0.8)
                        : Colors.black26,
                    blurRadius: 20,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: baseSize * 0.050,
                  ),
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: mqttController.isConnected.value
                        ? Color(0xFF24C48E)
                        : Colors.red,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: baseSize * 0.09,
                    child: Obx(
                      () => Text(
                        mqttController.deviceConnections[deviceid] == false
                            ? "--.-"
                            : "${mqttController.tempcsmSp.value.round()}°C",
                        style: TextStyle(
                          fontFamily: 'DS-Digital',
                          fontSize: shortestSide * 0.16,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: baseSize * 0.015,
                  ),
                  Text("Set Point",
                      style: TextStyle(
                        fontSize: 16,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: baseSize * 0.32, bottom: baseSize * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                      padding: EdgeInsets.symmetric(
                          horizontal: shortestSide * 0.12,
                          vertical: baseSize * 0.001),
                    ),
                    onPressed: () {
                      mqttController.isUserInteracting.value = true;
                      if (mqttController.tempcsmSp.value > 0) {
                        mqttController.tempcsmSp.value -= 1;

                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          mqttController.updateSetpointcsm(
                              mqttController.tempcsmSp.value.toDouble());
                          mqttController.isUserInteracting.value = false;
                        });
                      }
                    },
                    child: Icon(
                      Icons.remove,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Container(
                    color: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                    width: shortestSide * 0.28,
                    height: baseSize * 0.05,
                    child: Center(
                      child: Text(
                        'Set Point'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                      padding: EdgeInsets.symmetric(
                          horizontal: shortestSide * 0.12,
                          vertical: baseSize * 0.001),
                    ),
                    onPressed: () {
                      mqttController.isUserInteracting.value = true;
                      if (mqttController.tempcsmSp.value < 40) {
                        mqttController.tempcsmSp.value += 1;

                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          mqttController.updateSetpointcsm(
                              mqttController.tempcsmSp.value.toDouble());
                          mqttController.isUserInteracting.value = false;
                        });
                      }
                    },
                    child: Icon(
                      Icons.add,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
