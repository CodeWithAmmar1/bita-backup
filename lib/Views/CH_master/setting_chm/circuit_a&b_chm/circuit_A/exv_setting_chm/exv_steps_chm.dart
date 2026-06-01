import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_a&b_chm/circuit_A/setpoint_setting_chm/setpoint_widget_chm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class ExvStepsChm extends StatefulWidget {
  final RxInt exvcurrentStep;
  final RxInt exvstepDelay;
  final RxInt exvmaxstep;
  final bool permissionExv;

  const ExvStepsChm(
      {super.key,
      required this.exvcurrentStep,
      required this.exvstepDelay,
      required this.exvmaxstep,
      required this.permissionExv});
  @override
  State<ExvStepsChm> createState() => _SettingState();
}

class _SettingState extends State<ExvStepsChm> {
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
            'EXV Step Setting',
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
                              "EXV Current Step",
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
                                () => Text(
                                  widget.exvcurrentStep.value.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
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
                              Get.to(() => ChmSetpointWidget(
                                    title: "EXV Step Delay",
                                    unit: "%",
                                    minValue: 0,
                                    maxValue: 1000,
                                    value: widget.exvstepDelay,
                                    onPublish: () {
                                      if (widget.permissionExv) {
                                        _mqttController
                                            .buildJsonPayloadCiruitA();
                                      } else {
                                        _mqttController
                                            .buildJsonPayloadCiruitB();
                                      }
                                    },
                                  ));
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
                                    "EXV Step Delay",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(
                                    () => Text(
                                      widget.exvstepDelay.value.toString(),
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
                              Get.to(() => ChmSetpointWidget(
                                    title: "EXV Max Step",
                                    unit: "",
                                    minValue: 0,
                                    maxValue: 1000,
                                    value: widget.exvmaxstep,
                                    onPublish: () {
                                      if (widget.permissionExv) {
                                        _mqttController
                                            .buildJsonPayloadCiruitA();
                                      } else {
                                        _mqttController
                                            .buildJsonPayloadCiruitB();
                                      }
                                    },
                                  ));
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
                                    "EXV Max Step",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(
                                    () => Text(
                                      widget.exvmaxstep.value.toString(),
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
          ],
        )));
  }
}
