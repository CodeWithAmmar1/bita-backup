import 'dart:async';

import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class BottomnavDm extends StatelessWidget {
  BottomnavDm({super.key});
  final MqttController mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    Timer? publishTimer;
    return Container(
      height: baseSize * 0.095,
      color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          mqttController.drainPower.value =
                              !mqttController.drainPower.value;
                        },
                        child: LoadSwitch(
                          height: baseSize * 0.055,
                          width: baseSize * 0.055,
                          value: mqttController.drainPower.value,
                          future: () async {
                            final newValue = !mqttController.drainPower.value;
                            mqttController.drainPower.value = newValue;
                            mqttController.isUserInteracting.value = true;
                            publishTimer?.cancel();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              mqttController.updateDrainPower(newValue);
                              publishTimer = Timer(Duration(seconds: 1), () {
                                mqttController.isUserInteracting.value = false;
                              });
                            });
                            await Future.delayed(Duration(milliseconds: 2000));
                            return newValue;
                          },
                          onChange: (_) {},
                          onTap: (val) {
                            log("damp switch change : $val");
                          },
                          animationDuration: const Duration(milliseconds: 500),
                          curveIn: Curves.easeInBack,
                          curveOut: Curves.easeOutBack,
                          style: SpinStyle.material,
                          switchDecoration: (value, loading) => BoxDecoration(
                            color: value
                                ? ThemeColor().actual.withValues(alpha: 0.2)
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          spinColor: (value) =>
                              value ? ThemeColor().actual : Colors.grey,
                          spinStrokeWidth: 3,
                          thumbDecoration: (value, loading) => BoxDecoration(
                            color: mqttController.drainPower.value
                                ? Colors.green
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.power_settings_new,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
            
                const SizedBox(height: 6),
                Text(
                  "Power".tr,
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: shortestSide * 0.030),
                ),
              ],
            );
          }),
          Obx(() {
            bool isOn = mqttController.dmpumpSwitch.value;
            bool isAuto = mqttController.dmpumpcontrol.value;
            return GestureDetector(
              onTap: () async {
                if (!isAuto) {
                  mqttController.toggleDMSwitch(1);
                  await Future.delayed(Duration(milliseconds: 500));
                  mqttController.dmpumpSwitch.value = !isOn;
                }
              },
              onLongPress: () {
                final isCurrentlyAuto = mqttController.dmpumpcontrol.value;
                if (isCurrentlyAuto) {
                  TextEditingController passwordController =
                      TextEditingController();
                  Get.dialog(Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 16,
                        right: 16,
                      ),
                      child: AlertDialog(
                        backgroundColor: ThemeColor().dialogBox,
                        title: Text(
                          "Enter Password".tr,
                          style: TextStyle(color: Colors.black),
                        ),
                        content: Obx(
                          () => TextField(
                            style: TextStyle(color: Colors.black),
                            controller: passwordController,
                            obscureText: mqttController.pumpPass.value,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    mqttController.pumpPass.value =
                                        !mqttController.pumpPass.value;
                                  },
                                  icon: mqttController.pumpPass.value
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        )
                                      : Icon(Icons.remove_red_eye,
                                          color: Colors.black)),
                              hintText: "Enter Password".tr,
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "cancel".tr,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              String enteredPassword =
                                  passwordController.text.trim();
                              if (enteredPassword == '1234') {
                                mqttController.dmpumpcontrol.value = false;
                                mqttController.updateDMPumpAutomation(false);
                                log("Pump mode changed to: Manual");
                                Get.back();
                              } else {
                                Get.snackbar('Error', 'Incorrect password',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            },
                            child: Text(
                              "Submit".tr,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                } else {
                  mqttController.dmpumpcontrol.value = true;
                  mqttController.updateDMPumpAutomation(true);
                  log("Pump mode changed to: Auto");
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IgnorePointer(
                        ignoring: isAuto,
                        child: LoadSwitch(
                          height: baseSize * 0.055,
                          width: baseSize * 0.055,
                          value: isOn,
                          future: () async {
                            mqttController.toggleDMSwitch(1);
                            await Future.delayed(Duration(milliseconds: 500));
                            return !isOn;
                          },
                          onChange: (_) {},
                          onTap: (val) {
                            log("pump switch change : $val");
                          },
                          animationDuration: const Duration(milliseconds: 500),
                          curveIn: Curves.easeInBack,
                          curveOut: Curves.easeOutBack,
                          style: SpinStyle.material,
                          switchDecoration: (value, loading) {
                            final isAuto = mqttController.dmpumpcontrol.value;
                            return BoxDecoration(
                              color: isAuto
                                  ? Colors.green.withOpacity(0.3)
                                  : value
                                      ? Colors.red.withValues(alpha: 0.2)
                                      : Colors.red[100],
                              borderRadius: BorderRadius.circular(30),
                            );
                          },
                          spinColor: (value) =>
                              value ? Colors.red : Colors.grey,
                          spinStrokeWidth: 3,
                          thumbDecoration: (value, loading) {
                            final isAuto = mqttController.dmpumpcontrol.value;
                            return BoxDecoration(
                              color: isAuto
                                  ? Colors.green
                                  : value
                                      ? Colors.red
                                      : Colors.red.shade300,
                              borderRadius: BorderRadius.circular(30),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          final isCurrentlyAuto =
                              mqttController.dmpumpcontrol.value;
                          if (isCurrentlyAuto) {
                            TextEditingController passwordController =
                                TextEditingController();
                            Get.dialog(Center(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                  left: 16,
                                  right: 16,
                                ),
                                child: AlertDialog(
                                  backgroundColor: ThemeColor().dialogBox,
                                  title: Text(
                                    "Enter Password".tr,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Obx(
                                    () => TextField(
                                      style: TextStyle(color: Colors.black),
                                      controller: passwordController,
                                      obscureText:
                                          mqttController.pumpPass.value,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              mqttController.pumpPass.value =
                                                  !mqttController
                                                      .pumpPass.value;
                                            },
                                            icon: mqttController.pumpPass.value
                                                ? Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.black,
                                                  )
                                                : Icon(Icons.remove_red_eye,
                                                    color: Colors.black)),
                                        hintText: "Enter Password".tr,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        "cancel".tr,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        String enteredPassword =
                                            passwordController.text.trim();
                                        if (enteredPassword == '1234') {
                                          mqttController.dmpumpcontrol.value =
                                              false;
                                          mqttController
                                              .updateDMPumpAutomation(false);
                                          log("Pump mode changed to: Manual");
                                          Get.back();
                                        } else {
                                          Get.snackbar(
                                              'Error', 'Incorrect password',
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white);
                                        }
                                      },
                                      child: Text(
                                        "Submit".tr,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          } else {
                            mqttController.dmpumpcontrol.value = true;
                            mqttController.updateDMPumpAutomation(true);
                            log("Pump mode changed to: Auto");
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isAuto)
                              const Text(
                                "Man",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            if (isAuto)
                              const Text(
                                "Auto",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(shortestSide * 0.009),
                    child: Text(
                      'pump_controller'.tr,
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: shortestSide * 0.030),
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
