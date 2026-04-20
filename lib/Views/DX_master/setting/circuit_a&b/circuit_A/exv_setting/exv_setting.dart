import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/exv_setting/exv_steps.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/exv_setting/min_max_exv.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/setpoint_setting/setpoint_widget.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ExvSetting extends StatelessWidget {
  final RxInt min;
  final RxInt max;
  final RxDouble integral;
  final RxDouble derivative;
  final RxDouble proportional;
  final RxInt superHeat;
  final bool permissionExv;
  final RxInt sucPressure;
  final RxInt disPressure;
  final RxDouble sucTemp;
  final RxDouble disTemp;
  final RxInt selectedEXVMode;
  final RxInt exvcurrentStep;
  final RxInt exvstepDelay;
  final RxInt exvmaxstep;
   ExvSetting({
    super.key,
    required this.selectedEXVMode,
    required this.sucPressure,
    required this.disPressure,
    required this.sucTemp,
    required this.disTemp,
    required this.permissionExv,
    required this.superHeat,
    required this.integral,
    required this.derivative,
    required this.proportional,
    required this.min,
    required this.max,
    required this.exvcurrentStep,
    required this.exvstepDelay,
    required this.exvmaxstep,
  });
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'EXV Settings',
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
            SizedBox(height: 10),
            Text(
              'Selection',
              style: TextStyle(
                  fontSize: Get.width * 0.055,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
            ),
            SizedBox(height: 10),
            Obx(
              () => ToggleSwitch(
                borderWidth: 2.0,
                borderColor: [ThemeColor().actual],
                minWidth: 90.0,
                minHeight: Get.height * 0.06,
                fontSize: 16.0,
                initialLabelIndex: selectedEXVMode.value,
                activeBgColor: [ThemeColor().actual],
                activeFgColor: Get.isDarkMode ? Colors.black : Colors.white,
                inactiveBgColor: Get.isDarkMode
                    ? ThemeColor().mode2Sec
                    : ThemeColor().mode1Sec,
                inactiveFgColor: Get.isDarkMode ? Colors.white : Colors.black,
                totalSwitches: 2,
                labels: ['EXV', 'TXV'],
                onToggle: (index) {
                  if (index != null) {
                    log('switched to: $index');
                    selectedEXVMode.value = index;
                    if (permissionExv) {
                      _mqttController.buildJsonPayloadCiruitA();
                    } else {
                      _mqttController.buildJsonPayloadCiruitB();
                    }
                    log('selectedEXVMode: ${selectedEXVMode.value}');
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            Obx(() {
              if (selectedEXVMode.value == 0) {
                return Column(
                  children: [
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Get.width * 0.22,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2
                                    : ThemeColor().mode1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Suction",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "Temp",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "$sucTemp°C",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: Get.width * 0.22,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2
                                    : ThemeColor().mode1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Suction",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "Pressure",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "$sucPressure PSI",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: Get.width * 0.22,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2
                                    : ThemeColor().mode1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Discharge",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "Temp",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "$disTemp°C",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: Get.width * 0.22,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2
                                    : ThemeColor().mode1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Discharge",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "Pressure",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "$disPressure PSI",
                                    style: TextStyle(
                                        fontSize: Get.width * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Get.isDarkMode
                              ? ThemeColor().mode2Sec
                              : ThemeColor().mode1Sec,
                        ),
                        padding: EdgeInsets.all(2),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'EXV Parameters',
                                style: TextStyle(
                                    fontSize: Get.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            Divider(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Get.isDarkMode
                                      ? ThemeColor().mode2
                                      : ThemeColor().mode1,
                                ),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'EXV Position',
                                        style: TextStyle(
                                            fontSize: Get.width * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Manual",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          LoadSwitch(
                                            height: Get.height * 0.038,
                                            width: Get.height * 0.08,
                                            value: permissionExv
                                                ? _mqttController
                                                    .exvPosiSwA.value
                                                : _mqttController
                                                    .exvPosiSwB.value,
                                            future: () async {
                                              if (permissionExv) {
                                                _mqttController
                                                    .exvPosiSwLoadingA
                                                    .value = true;
                                                final newValue =
                                                    !_mqttController
                                                        .exvPosiSwA.value;
                                                await _mqttController
                                                    .exvPosiSwitchA(
                                                  newValue,
                                                );
                                                _mqttController
                                                    .exvPosiSwLoadingA
                                                    .value = false;
                                                return newValue;
                                              } else {
                                                _mqttController
                                                    .exvPosiSwLoadingB
                                                    .value = true;
                                                final newValue =
                                                    !_mqttController
                                                        .exvPosiSwB.value;
                                                await _mqttController
                                                    .exvPosiSwitchB(
                                                  newValue,
                                                );
                                                _mqttController
                                                    .exvPosiSwLoadingB
                                                    .value = false;
                                                return newValue;
                                              }
                                            },
                                            onChange: (_) {},
                                            onTap: (val) {},
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            curveIn: Curves.easeInBack,
                                            curveOut: Curves.easeOutBack,
                                            style: SpinStyle.material,
                                            switchDecoration:
                                                (value, loading) =>
                                                    BoxDecoration(
                                              color: value
                                                  ? ThemeColor()
                                                      .actual
                                                      .withValues(alpha: 0.2)
                                                  : Colors.red[100],
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: value
                                                      ? ThemeColor()
                                                          .actual
                                                          .withValues(
                                                              alpha: 0.2)
                                                      : Colors.red.withValues(
                                                          alpha: 0.2),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            spinColor: (value) => value
                                                ? ThemeColor().actual
                                                : const Color.fromARGB(
                                                    255, 255, 77, 77),
                                            spinStrokeWidth: 3,
                                            thumbDecoration: (value, loading) =>
                                                BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: value
                                                      ? ThemeColor()
                                                          .actual
                                                          .withValues(
                                                              alpha: 0.2)
                                                      : Colors.red.withValues(
                                                          alpha: 0.2),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Auto",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                 SetpointWidget(
                                      title: "Super Heat",
                                      unit: "°C",
                                      minValue:2,
                                      maxValue: 20,
                                      value: superHeat,
                                      onPublish: () {
                                        if (permissionExv) {
                                          _mqttController
                                              .buildJsonPayloadCiruitA();
                                        } else {
                                          _mqttController
                                              .buildJsonPayloadCiruitB();
                                        }
                                      },
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'Super Heat & Set Point'.tr,
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SetpointEXVWidget(
                                      title: "Proportional",
                                      unit: "°C",
                                      minValue: 0.0,
                                      maxValue: 20.0,
                                      value: proportional,
                                      onPublish: () {
                                        if (permissionExv) {
                                          _mqttController
                                              .buildJsonPayloadCiruitA();
                                        } else {
                                          _mqttController
                                              .buildJsonPayloadCiruitB();
                                        }
                                      },
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'Proportional'.tr,
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SetpointEXVWidget(
                                      title: "Integral",
                                      unit: "°C",
                                      minValue: 0.0,
                                      maxValue: 20.0,
                                      value: integral,
                                      onPublish: () {
                                        if (permissionExv) {
                                          _mqttController
                                              .buildJsonPayloadCiruitA();
                                        } else {
                                          _mqttController
                                              .buildJsonPayloadCiruitB();
                                        }
                                      },
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'Integral'.tr,
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SetpointEXVWidget(
                                      title: "Deravtive",
                                      unit: "°C",
                                      minValue: 0.0,
                                      maxValue: 20.0,
                                      value: derivative,
                                      onPublish: () {
                                        if (permissionExv) {
                                          _mqttController
                                              .buildJsonPayloadCiruitA();
                                        } else {
                                          _mqttController
                                              .buildJsonPayloadCiruitB();
                                        }
                                      },
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'Deravtive'.tr,
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => MinMaxExv(
                                      permission: permissionExv,
                                      maxx: max,
                                      minn: min,
                                    ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'Min & Max EXV'.tr,
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => ExvSteps(permissionExv: permissionExv,
                                      exvcurrentStep: exvcurrentStep,
                                      exvstepDelay: exvstepDelay,
                                      exvmaxstep: exvmaxstep, 
                                ));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.settings,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20,
                                ),
                                title: Text(
                                  'EXV Steps'.tr,
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}
