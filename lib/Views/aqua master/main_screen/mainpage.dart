import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/aqua%20master/boiler_Container/boiler_setting.dart';
import 'package:testappbita/Views/aqua%20master/comfort_Container/comfort_setting.dart';
import 'package:testappbita/Views/aqua%20master/cooler_Container/cooler_setting.dart';
import 'package:testappbita/Views/aqua%20master/dailog/pass_dailog.dart';
import 'package:testappbita/Views/aqua%20master/setting_Page/setting.dart';
import 'package:testappbita/Views/aqua%20master/temperature_config/temp_config.dart';
import 'package:testappbita/Views/aqua%20master/water_indicator/level.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  _MainpageState createState() => _MainpageState();
}

late String deviceName;
late String deviceid;
Timer? publishTimer;

class _MainpageState extends State<Mainpage> {
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

  final MqttController mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0,
      ),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset(
                "assets/images/aqua_master.png",
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 8),
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
          actions: [
            Obx(() {
              final isConnected =
                  mqttController.deviceConnections[deviceid] ?? false;
              return isConnected
                  ? CustomIconButton(
                      nextcolor: Colors.blue.shade800,
                      backgroundcolor1: Colors.grey.withOpacity(0.2),
                      color: Colors.red,
                      icon: Icons.cell_tower,
                      onPressed: () {},
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomIconButton(
                          nextcolor: Colors.black,
                          backgroundcolor1: Colors.yellow.withOpacity(0.7),
                          color: Colors.black,
                          icon: Icons.cell_tower,
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child:
                              Icon(Icons.cancel, size: 16, color: Colors.red),
                        ),
                      ],
                    );
            }),
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Enter Password'.tr,
                  content: PasswordDialog(),
                );
              },
              icon: Icon(Icons.settings, color: Colors.black),
            ),
            const SizedBox(width: 20),
          ],
          backgroundColor: ThemeColor().actual,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                WaterLevelContainer(
                  deviceid: deviceid,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            border: Border.all(
                              color:
                                  // mqttController.modeAqm.value &&
                                  (mqttController.coolerSwitch.value == 1 ||
                                          mqttController.coolerSwitch.value ==
                                              0)
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.circular(shortestSide * 0.03),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => TemperatureDialog(
                                          maxTemp: 30,
                                          switchStatus:
                                              mqttController.coolerSwitch,
                                          onslider: (value) {
                                            mqttController.changeCooler(value);
                                          },
                                          onsliderEnd: () {
                                            mqttController
                                                .buildJsonPayloadAQM();
                                          },
                                          onTapAdd: () {
                                            int? value = int.tryParse(
                                                mqttController.coolerSp.value);
                                            mqttController
                                                .isUserInteracting.value = true;
                                            if (value != null && value < 30) {
                                              value += 1;
                                              mqttController.changeCooler(
                                                  value.toDouble());
                                              publishTimer?.cancel();
                                              publishTimer = Timer(
                                                  Duration(seconds: 1), () {
                                                mqttController
                                                    .buildJsonPayloadAQM();
                                                publishTimer = Timer(
                                                    Duration(seconds: 1), () {
                                                  mqttController
                                                      .isUserInteracting
                                                      .value = false;
                                                });
                                              });
                                            }
                                          },
                                          onTapSub: () {
                                            mqttController
                                                .isUserInteracting.value = true;
                                            int? value = int.tryParse(
                                                mqttController.coolerSp.value);
                                            if (value != null && value > 0) {
                                              value -= 1;
                                              mqttController.changeCooler(
                                                  value.toDouble());
                                              publishTimer?.cancel();
                                              publishTimer = Timer(
                                                  Duration(seconds: 1), () {
                                                mqttController
                                                    .buildJsonPayloadAQM();
                                                publishTimer = Timer(
                                                    Duration(seconds: 1), () {
                                                  mqttController
                                                      .isUserInteracting
                                                      .value = false;
                                                });
                                              });
                                            }
                                          },
                                          title: 'cooler'.tr,
                                          temperature: mqttController
                                              .comfortAndCoolerTemp,
                                          setpoint: mqttController.coolerSp,
                                        ));
                                  },
                                  child: Container(
                                    height: baseSize * 0.08,
                                    width: shortestSide * 0.25,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2Sec
                                          : ThemeColor().mode1Sec,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CoolerViewSetting(
                                        deviceid: deviceid, index: 0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: baseSize * 0.05,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.03),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? mqttController
                                                        .coolerState.value ==
                                                    "1"
                                                ? 'on'.tr
                                                : mqttController.coolerState
                                                            .value ==
                                                        "0"
                                                    ? 'off'.tr
                                                    : '--'
                                            : '--',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mqttController
                                                      .coolerState.value ==
                                                  "1"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            border: Border.all(
                              color:
                                  // mqttController.modeAqm.value &&
                                  (mqttController.comfortSwitch.value == 1 ||
                                          mqttController.comfortSwitch.value ==
                                              0)
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.circular(shortestSide * 0.03),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => TemperatureDialog(
                                          maxTemp: 30,
                                          switchStatus:
                                              mqttController.comfortSwitch,
                                          onslider: (value) {
                                            mqttController.changeComfort(value);
                                          },
                                          onsliderEnd: () {
                                            mqttController
                                                .buildJsonPayloadAQM();
                                          },
                                          onTapAdd: () {
                                            int? value = int.tryParse(
                                                mqttController.comfortSp.value);
                                            mqttController
                                                .isUserInteracting.value = true;
                                            if (value != null && value < 30) {
                                              value += 1;
                                              mqttController.changeComfort(
                                                  value.toDouble());
                                              publishTimer?.cancel();
                                              publishTimer = Timer(
                                                  Duration(seconds: 1), () {
                                                mqttController
                                                    .buildJsonPayloadAQM();
                                                publishTimer = Timer(
                                                    Duration(seconds: 1), () {
                                                  mqttController
                                                      .isUserInteracting
                                                      .value = false;
                                                });
                                              });
                                            }
                                          },
                                          onTapSub: () {
                                            mqttController
                                                .isUserInteracting.value = true;
                                            int? value = int.tryParse(
                                                mqttController.comfortSp.value);
                                            if (value != null && value > 0) {
                                              value -= 1;
                                              mqttController.changeComfort(
                                                  value.toDouble());
                                              publishTimer?.cancel();
                                              publishTimer = Timer(
                                                  Duration(seconds: 1), () {
                                                mqttController
                                                    .buildJsonPayloadAQM();
                                                publishTimer = Timer(
                                                    Duration(seconds: 1), () {
                                                  mqttController
                                                      .isUserInteracting
                                                      .value = false;
                                                });
                                              });
                                            }
                                          },
                                          title: 'comfort'.tr,
                                          temperature: mqttController
                                              .comfortAndCoolerTemp,
                                          setpoint: mqttController.comfortSp,
                                        ));
                                  },
                                  child: Container(
                                    height: baseSize * 0.08,
                                    width: shortestSide * 0.25,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2Sec
                                          : ThemeColor().mode1Sec,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ComfortViewSetting(
                                        deviceid: deviceid, index: 2),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: baseSize * 0.05,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.03),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? mqttController
                                                        .comfortState.value ==
                                                    "1"
                                                ? 'on'.tr
                                                : mqttController.comfortState
                                                            .value ==
                                                        "0"
                                                    ? 'off'.tr
                                                    : '--'
                                            : '--',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mqttController
                                                      .comfortState.value ==
                                                  "1"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            border: Border.all(
                              color:
                                  // mqttController.modeAqm.value &&
                                  (mqttController.boilerSwitch.value == 1 ||
                                          mqttController.boilerSwitch.value ==
                                              0)
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.circular(shortestSide * 0.03),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => TemperatureDialog(
                                          maxTemp: 40,
                                          switchStatus:
                                              mqttController.boilerSwitch,
                                          onslider: (value) {
                                            mqttController.changeBoiler(value);
                                          },
                                          onsliderEnd: () {
                                            mqttController
                                                .buildJsonPayloadAQM();
                                          },
                                          onTapAdd: () {
                                            int? value = int.tryParse(
                                                mqttController.boilerSp.value);
                                            mqttController
                                                .isUserInteracting.value = true;
                                            if (value != null && value < 40) {
                                              value += 1;
                                              mqttController.changeBoiler(
                                                  value.toDouble());
                                              publishTimer?.cancel();
                                              publishTimer = Timer(
                                                  Duration(seconds: 1), () {
                                                mqttController
                                                    .buildJsonPayloadAQM();
                                                publishTimer = Timer(
                                                    Duration(seconds: 1), () {
                                                  mqttController
                                                      .isUserInteracting
                                                      .value = false;
                                                });
                                              });
                                            }
                                          },
                                          onTapSub: () {
                                            mqttController
                                                .isUserInteracting.value = true;
                                            int? value = int.tryParse(
                                                mqttController.boilerSp.value);
                                            if (value != null && value > 0) {
                                              value -= 1;
                                              mqttController.changeBoiler(
                                                  value.toDouble());
                                              publishTimer?.cancel();
                                              publishTimer = Timer(
                                                  Duration(seconds: 1), () {
                                                mqttController
                                                    .buildJsonPayloadAQM();
                                                publishTimer = Timer(
                                                    Duration(seconds: 1), () {
                                                  mqttController
                                                      .isUserInteracting
                                                      .value = false;
                                                });
                                              });
                                            }
                                          },
                                          title: 'boiler'.tr,
                                          temperature:
                                              mqttController.boilerTemp,
                                          setpoint: mqttController.boilerSp,
                                        ));
                                  },
                                  child: Container(
                                    height: baseSize * 0.08,
                                    width: shortestSide * 0.25,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2Sec
                                          : ThemeColor().mode1Sec,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: BoilerViewSetting(
                                        deviceid: deviceid, index: 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: baseSize * 0.05,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.03),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? mqttController
                                                        .boilerState.value ==
                                                    "1"
                                                ? 'on'.tr
                                                : mqttController.boilerState
                                                            .value ==
                                                        "0"
                                                    ? 'off'.tr
                                                    : '--'
                                            : '--',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mqttController
                                                      .boilerState.value ==
                                                  "1"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            border: Border.all(
                              color:
                                  // mqttController.modeAqm.value &&
                                  (mqttController.boosterSwitch.value == 1 ||
                                          mqttController.boosterSwitch.value ==
                                              0)
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.circular(shortestSide * 0.03),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: baseSize * 0.08,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.04),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          mqttController
                                              .bottomSheetboosterButton(
                                                  "booster".tr);
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              'booster'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Get.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Pump'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Get.isDarkMode
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: baseSize * 0.05,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.03),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? mqttController
                                                        .boosterState.value ==
                                                    "1"
                                                ? 'on'.tr
                                                : mqttController.boosterState
                                                            .value ==
                                                        "0"
                                                    ? 'off'.tr
                                                    : '--'
                                            : '--',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mqttController
                                                      .boosterState.value ==
                                                  "1"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  // mqttController.modeAqm.value &&
                                  (mqttController.makeupSwitch.value == 1 ||
                                          mqttController.makeupSwitch.value ==
                                              0)
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                              width: 1,
                            ),
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            borderRadius:
                                BorderRadius.circular(shortestSide * 0.03),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: baseSize * 0.08,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.04),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          mqttController.bottomSheetmakeButton(
                                              'makeup'.tr);
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              'makeup'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Get.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Pump'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Get.isDarkMode
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: baseSize * 0.05,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.03),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? mqttController
                                                        .makeupState.value ==
                                                    "1"
                                                ? 'on'.tr
                                                : mqttController.makeupState
                                                            .value ==
                                                        "0"
                                                    ? 'off'.tr
                                                    : '--'
                                            : '--',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mqttController
                                                      .makeupState.value ==
                                                  "1"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (mqttController.recirculorSwitch.value ==
                                          1 ||
                                      mqttController.recirculorSwitch.value ==
                                          0)
                                  ? Colors.red
                                  : Get.isDarkMode
                                      ? ThemeColor().mode2
                                      : ThemeColor().mode1,
                              width: 1,
                            ),
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            borderRadius:
                                BorderRadius.circular(shortestSide * 0.03),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: baseSize * 0.08,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.04),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          mqttController
                                              .bottomSheetreciculorButton(
                                                  'recirculor'.tr);
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              'recirculor'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Get.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Pump'.tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Get.isDarkMode
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: baseSize * 0.05,
                                  width: shortestSide * 0.25,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        shortestSide * 0.03),
                                  ),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? mqttController.recirculorState
                                                        .value ==
                                                    "1"
                                                ? 'on'.tr
                                                : mqttController.recirculorState
                                                            .value ==
                                                        "0"
                                                    ? 'off'.tr
                                                    : '--'
                                            : '--',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: mqttController
                                                      .recirculorState.value ==
                                                  "1"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: baseSize * 0.111,
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    mqttController.showBottomSheetSeason();
                  },
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.dashboard,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                      mqttController.isSummer.value ? 'winter'.tr : 'summer'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Enter Password'.tr,
                      content: PasscodeDialog(
                        onPasscodeEntered: (passcode) {
                          if (passcode == '1234') {
                            Get.back();
                            mqttController.showBottomSheetMode();
                          } else {
                            Get.snackbar('error'.tr, 'wrong_password'.tr,
                                backgroundColor: Colors.red);
                          }
                        },
                      ),
                    );
                  },
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.settings_outlined,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                      mqttController.modeAqm.value ? 'auto'.tr : 'manual'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Obx(() => GestureDetector(
                      onTap: () {
                        if (mqttController.modeAqm.value == false) {
                          Get.defaultDialog(
                            title: 'notice'.tr,
                            middleText: 'your_mode_is_manual'.tr,
                            middleTextStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            confirm: ElevatedButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'ok'.tr,
                                style: TextStyle(color: ThemeColor().actual),
                              ),
                            ),
                          );
                        } else {
                          mqttController.showDayAndHourPicker(
                            context,
                            'system_operation_scheduling',
                            onUpdated: () =>
                                mqttController.buildJsonPayloadAQM(),
                          );
                        }
                      },
                      child: buildIconContainer(
                        context,
                        Icons.calendar_month,
                        mqttController.toggleValue.value
                            ? Color(0xFF24C48E)
                            : Colors.grey,
                        Colors.grey.shade200,
                        mqttController.toggleValue.value
                            ? 'enabled'.tr
                            : 'disabled'.tr,
                        mqttController.toggleValue.value &&
                                mqttController.tmatch.value
                            ? Colors.green
                            : mqttController.toggleValue.value &&
                                    !mqttController.tmatch.value
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                        showTick: mqttController.toggleValue.value,
                        tickColor: mqttController.scheduleTickColor,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildIconContainer(
  BuildContext context,
  dynamic icon,
  Color iconColor,
  Color color,
  String text,
  Color txtcolor, {
  bool showTick = false,
  Color tickColor = Colors.grey,
}) {
  final media = MediaQuery.of(context);
  final isPortrait = media.orientation == Orientation.portrait;
  final baseSize = isPortrait ? media.size.height : media.size.width;
  final shortestSide = media.size.shortestSide;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: baseSize * 0.05,
            width: shortestSide * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: icon is Widget
                  ? icon
                  : Icon(icon as IconData?, color: iconColor),
            ),
          ),
          if (showTick)
            Positioned(
              bottom: -5,
              right: -5,
              child: Icon(
                Icons.check_circle,
                color: tickColor,
                size: 18,
              ),
            ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        text.tr,
        style: TextStyle(
          color: txtcolor,
        ),
      ),
    ],
  );
}

class PasswordDialog extends StatefulWidget {
  const PasswordDialog({
    super.key,
  });
  @override
  // ignore: library_private_types_in_public_api
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool _obscureText = true;

  void _checkPassword() {
    if (_passwordController.text == '1234') {
      Get.back();
      Get.to(TempConfig());
    } else {
      setState(() {
        errorText = 'wrong_password'.tr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: errorText.isNotEmpty ? errorText : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPassword,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit'.tr,
                  style: TextStyle(color: ThemeColor().actual),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
