import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_b_user_chm/FanB_Setpoint_chm/fanB_setpoint_chm.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_b_user/FanB_Setpoint/fanB_setpoint.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/button/custom_toggle.dart' show CustomToggle;
import 'package:testappbita/utils/theme/theme.dart';

class CondensorBFanSettingChm extends StatefulWidget {
  const CondensorBFanSettingChm({super.key});

  @override
  State<CondensorBFanSettingChm> createState() => _SystemSetpointState();
}

class _SystemSetpointState extends State<CondensorBFanSettingChm> {
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
                  height: 170,
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
                                  value: _mqttController.fan1and2BSwitch.value,
                                  onTap: () async {
                                    _mqttController.fan1and2BSwLoading.value =
                                        true;
                                    final newValue =
                                        !_mqttController.fan1and2BSwitch.value;
                                    await _mqttController.fan1and2B(newValue);
                                    _mqttController.fan1and2BSwLoading.value =
                                        false;
                                    return newValue;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {

                                  Get.to(() => FanbSetpoint(
                                    title: "Fan 1&2 high Limit",
                                    initialvalue:
                                        _mqttController.fan1and2HighBLimit,
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
                                      ()=> Text(
                                        "${_mqttController.fan1and2HighBLimit.value}",
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

                                  Get.to(() => FanbSetpointChm(
                                    title: "Fan 1&2 high Limit",
                                    initialvalue:
                                        _mqttController.fan1and2LowBLimit,
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
                                      ()=> Text(
                                        "${_mqttController.fan1and2LowBLimit.value}",
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
                  height: 170,
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
                                  value: _mqttController.fan3and4BSwitch.value,
                                  onTap: () async {
                                    _mqttController.fan3and4BSwLoading.value =
                                        true;
                                    final newValue =
                                        !_mqttController.fan3and4BSwitch.value;
                                    await _mqttController.fan3and4B(newValue);
                                    _mqttController.fan3and4BSwLoading.value =
                                        false;
                                    return newValue;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                       GestureDetector(
                              onTap: () {

                                  Get.to(() => FanbSetpointChm(
                                    title: "Fan 3&4 high Limit",
                                    initialvalue:
                                        _mqttController.fan3and4HighBLimit,
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
                                      ()=> Text(
                                        "${_mqttController.fan3and4HighBLimit.value}",
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

                                  Get.to(() => FanbSetpointChm(
                                    title: "Fan 3&4 high Limit",
                                    initialvalue:
                                        _mqttController.fan3and4LowBLimit,
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
                                      ()=> Text(
                                        "${_mqttController.fan3and4LowBLimit.value}",
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
                  height: 170,
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
                                  value: _mqttController.fan5and6BSwitch.value,
                                  onTap: () async {
                                    _mqttController.fan5and6BSwLoading.value =
                                        true;
                                    final newValue =
                                        !_mqttController.fan5and6BSwitch.value;
                                    await _mqttController.fan5and6B(newValue);
                                    _mqttController.fan5and6BSwLoading.value =
                                        false;
                                    return newValue;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                               GestureDetector(
                              onTap: () {

                                  Get.to(() => FanbSetpointChm(
                                    title: "Fan 3&4 high Limit",
                                    initialvalue:
                                        _mqttController.fan5and6HighBLimit,
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
                                      ()=> Text(
                                        "${_mqttController.fan5and6HighBLimit.value}",
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

                                  Get.to(() => FanbSetpointChm(
                                    title: "Fan 5&6 high Limit",
                                    initialvalue:
                                        _mqttController.fan5and6LowBLimit,
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
                                      ()=> Text(
                                        "${_mqttController.fan5and6LowBLimit.value}",
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
