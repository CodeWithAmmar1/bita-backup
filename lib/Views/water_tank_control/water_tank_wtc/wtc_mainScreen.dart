import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/Views/water_tank_control/water_tank_wtc/bottom_nav_wtc.dart';
import 'package:testappbita/Views/water_tank_control/wtcWaterLevel/wtcWaterlevel.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class WtcMainscreen extends StatefulWidget {
  const WtcMainscreen({super.key});

  @override
  WtcMainscreenState createState() => WtcMainscreenState();
}
late String deviceName;
late String deviceid;
Timer? publishTimer;
final SensorSwitchController controller = Get.put(SensorSwitchController());
final MqttController mqttController = Get.find<MqttController>();

class WtcMainscreenState extends State<WtcMainscreen> {
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
                        bool newValue = !mqttController.wtcmaincontrol.value;
                        mqttController.wtcmaincontrol.value = newValue;
                        mqttController.wtcupdatePower(newValue);
                      },
                      child: Row(
                        children: [
                          Text(
                            mqttController.deviceConnections[deviceid] ?? false
                                ? mqttController.wtcmaincontrol.value
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
                              value: mqttController.wtcmaincontrol.value,
                              onChanged: (val) {
                                mqttController.wtcupdatePower(val);
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
                  Obx(
                    () => Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              if (mqttController.wtcmaincontrol.value == true)
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
                                  min: 10,
                                  max: 50,
                                  initialValue: mqttController
                                      .wtclastCMValue.value
                                      .toDouble()
                                      .clamp(10, 50),
                                  onChangeStart: (_) {
                                    mqttController.isUserInteracting.value =
                                        true;
                                  },
                                  onChange: (value) {
                                    mqttController.isUserInteracting.value =
                                        true;
                                    mqttController.updateTemperaturewtc(value);
                                  },
                                  onChangeEnd: (double value) {
                                    publishTimer?.cancel();
                                    publishTimer =
                                        Timer(Duration(seconds: 1), () {
                                      mqttController.wtcsendData(
                                          Map<String, dynamic>.from(
                                              mqttController.wtcreceivedData));
                                      mqttController.isUserInteracting.value =
                                          false;
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
                                          mqttController.wtcmaincontrol.value ==
                                                      false ||
                                                  mqttController
                                                              .deviceConnections[
                                                          deviceid] ==
                                                      false
                                              ? "--.-"
                                              : "${mqttController.wtclastCMValue.value.round()}°C",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          mqttController.wtcmaincontrol.value ==
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
                                            mqttController.wtcmaincontrol
                                                            .value ==
                                                        false ||
                                                    mqttController
                                                                .deviceConnections[
                                                            deviceid] ==
                                                        false
                                                ? ""
                                                : "${mqttController.wtccmtemperature.value}°C",
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
                              if (mqttController.wtcmaincontrol.value == true)
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
                                          mqttController
                                              .isUserInteracting.value = true;
                                          if (mqttController
                                                  .wtclastCMValue.value >
                                              10) {
                                            mqttController
                                                .wtclastCMValue.value -= 1;
                                            mqttController.updateTemperaturewtc(
                                                mqttController
                                                    .wtclastCMValue.value
                                                    .toDouble());

                                            publishTimer?.cancel();
                                            publishTimer =
                                                Timer(Duration(seconds: 1), () {
                                              mqttController.wtcsendData(
                                                  Map<String, dynamic>.from(
                                                      mqttController
                                                          .wtcreceivedData));
                                              mqttController.isUserInteracting
                                                  .value = false;
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
                                          mqttController
                                              .isUserInteracting.value = true;
                                          if (mqttController
                                                  .wtclastCMValue.value <
                                              50) {
                                            mqttController
                                                .wtclastCMValue.value += 1;

                                            mqttController.updateTemperaturewtc(
                                                mqttController
                                                    .wtclastCMValue.value
                                                    .toDouble());
                                            publishTimer?.cancel();
                                            publishTimer =
                                                Timer(Duration(seconds: 1), () {
                                              mqttController.wtcsendData(
                                                  Map<String, dynamic>.from(
                                                      mqttController
                                                          .wtcreceivedData));
                                              mqttController.isUserInteracting
                                                  .value = false;
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
                              if (mqttController.wtcmaincontrol.value == false)
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
                  ),
                  Wtcwaterlevel(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: baseSize * 0.08,
                          width: shortestSide * 0.39,
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
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? mqttController.wtcfan.value == "1"
                                          ? 'on'.tr
                                          : 'off'.tr
                                      : '--',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: shortestSide * 0.39,
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
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  mqttController.deviceConnections[deviceid] ??
                                          false
                                      ? mqttController.wtcpump.value == "1"
                                          ? 'on'.tr
                                          : 'off'.tr
                                      : '--',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: mqttController.wtcmaincontrol.value == true
                ? BottomNavWtc()
                : SizedBox(
                    height: baseSize * 0.095,
                  )),
      ),
    );
  }
}
