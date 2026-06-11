import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/setpoint_fan_setting/fanA_setpoint.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/button/custom_toggle.dart' show CustomToggle;
import 'package:testappbita/utils/theme/theme.dart';

class CondensorFanSetting extends StatefulWidget {
  final bool permission;
  const CondensorFanSetting({super.key, required this.permission});

  @override
  State<CondensorFanSetting> createState() => _SystemSetpointState();
}

class _SystemSetpointState extends State<CondensorFanSetting> {
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'Condensor Fan Setting',
            style: TextStyle(
                fontSize: Get.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: widget.permission ? 170 : 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Fan 1 & 2",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Obx(
                                () => CustomToggle(
                                  title: ''.tr,
                                  value: _mqttController.fan1and2ASwitch.value,
                                  onTap: () async {
                                    _mqttController.fan1and2ASwLoading.value =
                                        true;
                                    final newValue =
                                        !_mqttController.fan1and2ASwitch.value;
                                    await _mqttController.fan1and2A(newValue,permission: widget.permission);
                                    _mqttController.fan1and2ASwLoading.value =
                                        false;
                                    return newValue;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (widget.permission)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => FanaSetpoint(permission: widget.permission,

                                      title: "Fan 1&2 high Limit",
                                      initialvalue:
                                          _mqttController.fan1and2HighALimit,
                                      min: 80,
                                      max: 350));
                                },
                                child: Container(
                                  height: 100,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: ThemeColor().actual)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "High Limit",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Obx(
                                        () => Text(
                                          "${_mqttController.fan1and2HighALimit.value}",
                                          style: TextStyle(
                                            fontFamily: 'DS-Digital',
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => FanaSetpoint(permission: widget.permission,

                                      title: "Fan 1&2 Low Limit",
                                      initialvalue:
                                          _mqttController.fan1and2LowALimit,
                                      min: 60,
                                      max: 250));
                                },
                                child: Container(
                                  height: 100,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? ThemeColor().mode2
                                          : ThemeColor().mode1,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: ThemeColor().actual)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Low Limit",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Obx(
                                        () => Text(
                                          "${_mqttController.fan1and2LowALimit.value}",
                                          style: TextStyle(
                                            fontFamily: 'DS-Digital',
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: widget.permission ? 170 : 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Fan 3 & 4",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Obx(
                                () => CustomToggle(
                                  title: ''.tr,
                                  value: _mqttController.fan3and4ASwitch.value,
                                  onTap: () async {
                                    _mqttController.fan3and4ASwLoading.value =
                                        true;
                                    final newValue =
                                        !_mqttController.fan3and4ASwitch.value;
                                    await _mqttController.fan3and4A(newValue,permission: widget.permission);
                                    _mqttController.fan3and4ASwLoading.value =
                                        false;
                                    return newValue;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                        if (widget.permission)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FanaSetpoint(
                                  permission: widget.permission,
                                    title: "Fan 3&4 high Limit",
                                    initialvalue:
                                        _mqttController.fan3and4HighALimit,
                                    min: 80,
                                    max: 350));
                              },
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border:
                                        Border.all(color: ThemeColor().actual)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "High Limit",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${_mqttController.fan3and4HighALimit.value}",
                                        style: TextStyle(
                                          fontFamily: 'DS-Digital',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FanaSetpoint(permission: widget.permission,

                                    title: "Fan 3&4 Low Limit",
                                    initialvalue:
                                        _mqttController.fan3and4LowALimit,
                                    min: 60,
                                    max: 250));
                              },
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border:
                                        Border.all(color: ThemeColor().actual)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Low Limit",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${_mqttController.fan3and4LowALimit.value}",
                                        style: TextStyle(
                                          fontFamily: 'DS-Digital',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                           height: widget.permission? 170:50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Fan 5 & 6",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Obx(
                                () => CustomToggle(
                                  title: ''.tr,
                                  value: _mqttController.fan5and6ASwitch.value,
                                  onTap: () async {
                                    _mqttController.fan5and6ASwLoading.value =
                                        true;
                                    final newValue =
                                        !_mqttController.fan5and6ASwitch.value;
                                    await _mqttController.fan5and6A(newValue,permission: widget.permission);
                                    _mqttController.fan5and6ASwLoading.value =
                                        false;
                                    return newValue;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                        if (widget.permission)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FanaSetpoint(permission: widget.permission,

                                    title: "Fan 5&6 high Limit",
                                    initialvalue:
                                        _mqttController.fan5and6HighALimit,
                                    min: 80,
                                    max: 350));
                              },
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border:
                                        Border.all(color: ThemeColor().actual)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "High Limit",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${_mqttController.fan5and6HighALimit.value}",
                                        style: TextStyle(
                                          fontFamily: 'DS-Digital',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FanaSetpoint(permission: widget.permission,

                                    title: "Fan 5&6 Low Limit",
                                    initialvalue:
                                        _mqttController.fan5and6LowALimit,
                                    min: 60,
                                    max: 250));
                              },
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? ThemeColor().mode2
                                        : ThemeColor().mode1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border:
                                        Border.all(color: ThemeColor().actual)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Low Limit",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${_mqttController.fan5and6LowALimit.value}",
                                        style: TextStyle(
                                          fontFamily: 'DS-Digital',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
