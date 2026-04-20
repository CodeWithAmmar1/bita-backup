import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/Views/control_master/controlWaterLevel/cmWaterlevel.dart';
import 'package:testappbita/Views/control_master/control_master/bottom_nav_cm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CMPannel extends StatefulWidget {
  const CMPannel({super.key});

  @override
  CMPannelState createState() => CMPannelState();
}

late String deviceName;
late String deviceid;
Timer? publishTimer;

final SensorSwitchController controller = Get.put(SensorSwitchController());

class CMPannelState extends State<CMPannel> {
  void updateTemperature(int newTemp) {
    setState(() {
      mqttController.lastCMValue.value = newTemp.toDouble();
    });
    mqttController.receivedData['temp1sp'] = newTemp;
    mqttController.receivedData.refresh();
    mqttController
        .sendData(Map<String, dynamic>.from(mqttController.receivedData));
  }

  final MqttController mqttController = Get.find<MqttController>();
  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
    mqttController.timeAm2.value = true;
  }

  @override
  void dispose() {
    super.dispose();
    mqttController.updatetopicSSIDvalue("");
    mqttController.timeAm2.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor:
                Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: const Color(0xFF24C48E),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Obx(() {
                    return GestureDetector(
                      onLongPress: () {
                        bool newValue = !mqttController.maincontrol.value;
                        mqttController.maincontrol.value = newValue;
                        mqttController.updatePower(newValue);
                      },
                      child: Row(
                        children: [
                          Text(
                            mqttController.deviceConnections[deviceid] ?? false
                                ? mqttController.maincontrol.value
                                    ? 'ON'.tr
                                    : 'OFF'.tr
                                : "--",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: mqttController.maincontrol.value,
                              onChanged: (val) {
                                mqttController.updatePower(val);
                              },
                              activeColor: Colors.green,
                              activeTrackColor:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
              title: Row(
                children: [
                  Image.asset(
                    "assets/images/control_master.png",
                    width: 45,
                    height: 45,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      deviceName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: Get.isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            if (mqttController.maincontrol.value == true)
                              SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  size: baseSize * 0.30,
                                  angleRange: 260,
                                  startAngle: 140,
                                  customWidths: CustomSliderWidths(
                                    trackWidth: baseSize * 0.004,
                                    progressBarWidth: baseSize * 0.004,
                                    handlerSize: baseSize * 0.012,
                                  ),
                                  customColors: CustomSliderColors(
                                    trackColor: Colors.grey[500],
                                    progressBarColors: [
                                      Color(0xFF24C48E),
                                      Color(0xFF24C456)
                                    ],
                                    dotColor: Color(0xFF24C48E),
                                  ),
                                ),
                                min: 0,
                                max: 35,
                                initialValue: mqttController.lastCMValue.value
                                    .toDouble()
                                    .clamp(0, 35),
                                onChangeStart: (_) {
                                  mqttController.isUserInteracting.value = true;
                                },
                                onChange: (double value) {
                                  mqttController.isUserInteracting.value = true;
                                  mqttController.lastCMValue.value = value;
                                },
                                onChangeEnd: (double value) {
                                  publishTimer?.cancel();
                                  publishTimer =
                                      Timer(Duration(seconds: 1), () {
                                    updateTemperature(value.toInt());
                                    publishTimer =
                                        Timer(Duration(seconds: 1), () {
                                      mqttController.isUserInteracting.value =
                                          false;
                                    });
                                  });
                                },
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
                                        ? ThemeColor()
                                            .actual
                                            .withValues(alpha: 0.8)
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
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: baseSize * 0.09,
                                    child: Obx(
                                      () => Text(
                                        mqttController.maincontrol.value ==
                                                    false ||
                                                mqttController
                                                            .deviceConnections[
                                                        deviceid] ==
                                                    false
                                            ? "--.-"
                                            : "${mqttController.lastCMValue.value.round()}°C",
                                        style: TextStyle(
                                          fontFamily: 'DS-Digital',
                                          fontSize: shortestSide * 0.16,
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: baseSize * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        mqttController.maincontrol.value ==
                                                false
                                            ? 'systemOff'.tr
                                            : 'waterTemp'.tr,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: mqttController
                                                      .maincontrol.value ==
                                                  false
                                              ? Colors.red
                                              : mqttController
                                                          .lastCMValue.value <
                                                      1
                                                  ? Colors.red
                                                  : Get.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          mqttController.maincontrol.value ==
                                                      false ||
                                                  mqttController
                                                              .deviceConnections[
                                                          deviceid] ==
                                                      false
                                              ? ""
                                              : " ${mqttController.cmtemperature.value}°C",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: mqttController
                                                          .lastCMValue.value <
                                                      1
                                                  ? Colors.red
                                                  : ThemeColor().actual),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (mqttController.maincontrol.value == true)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: baseSize * 0.3,
                                    bottom: baseSize * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Get.isDarkMode
                                            ? ThemeColor().mode2Sec
                                            : ThemeColor().mode1Sec,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 3,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: shortestSide * 0.12,
                                            vertical: baseSize * 0.001),
                                      ),
                                      onPressed: () {
                                        mqttController.isUserInteracting.value =
                                            true;
                                        if (mqttController.lastCMValue.value >
                                            0) {
                                          mqttController.lastCMValue.value -= 1;

                                          publishTimer?.cancel();
                                          publishTimer =
                                              Timer(Duration(seconds: 1), () {
                                            updateTemperature(mqttController
                                                .lastCMValue.value
                                                .toInt());
                                            publishTimer =
                                                Timer(Duration(seconds: 1), () {
                                              mqttController.isUserInteracting
                                                  .value = false;
                                            });
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
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
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Get.isDarkMode
                                            ? ThemeColor().mode2Sec
                                            : ThemeColor().mode1Sec,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 3,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: shortestSide * 0.12,
                                            vertical: baseSize * 0.001),
                                      ),
                                      onPressed: () {
                                        mqttController.isUserInteracting.value =
                                            true;
                                        if (mqttController.lastCMValue.value <
                                            35) {
                                          mqttController.lastCMValue.value += 1;

                                          publishTimer?.cancel();
                                          publishTimer =
                                              Timer(Duration(seconds: 1), () {
                                            updateTemperature(mqttController
                                                .lastCMValue.value
                                                .toInt());
                                            publishTimer =
                                                Timer(Duration(seconds: 1), () {
                                              mqttController.isUserInteracting
                                                  .value = false;
                                            });
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (mqttController.maincontrol.value == false)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: baseSize * 0.3,
                                    bottom: baseSize * 0.03),
                                child: Container(
                                  height: 50,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CMWaterLevelContainer(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: baseSize * 0.08,
                            width: shortestSide * 0.36,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2Sec
                                  : ThemeColor().mode1Sec,
                              border: Border.all(
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2Sec
                                    : ThemeColor().mode1Sec,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.circular(shortestSide * 0.04),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "fan".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController
                                                .deviceConnections[deviceid] ??
                                            false
                                        ? mqttController.fan.value == "1"
                                            ? 'on'.tr
                                            : 'off'.tr
                                        : '--',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: baseSize * 0.08,
                            width: shortestSide * 0.36,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2Sec
                                  : ThemeColor().mode1Sec,
                              border: Border.all(
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2Sec
                                    : ThemeColor().mode1Sec,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.circular(shortestSide * 0.04),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "pump".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController
                                                .deviceConnections[deviceid] ??
                                            false
                                        ? mqttController.pump.value == "1"
                                            ? 'on'.tr
                                            : 'off'.tr
                                        : '--',
                                    style: TextStyle(fontSize: 14),
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
            bottomNavigationBar: mqttController.maincontrol.value == true
                ? BottomNavCm()
                : SizedBox(
                    height: baseSize * 0.095,
                  )),
      ),
    );
  }
}
