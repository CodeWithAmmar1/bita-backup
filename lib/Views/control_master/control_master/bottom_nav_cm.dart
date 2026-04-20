import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class BottomNavCm extends StatelessWidget {
  BottomNavCm({super.key});
  final MqttController mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return Container(
      height: baseSize * 0.095,
      color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() {
            bool isOn = mqttController.fanSwitch.value;
            bool isAuto = mqttController.fancontrol.value;
            return GestureDetector(
              onTap: () async {
                if (!isAuto) {
                  mqttController.toggleSwitchf(0);
                  await Future.delayed(Duration(milliseconds: 500));
                  mqttController.fanSwitch.value = !isOn;
                }
              },
              onLongPress: () {
                final isCurrentlyAuto = mqttController.fancontrol.value;
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          "Enter Password".tr,
                          style: const TextStyle(color: Colors.black),
                        ),
                        content: Obx(
                          () => TextField(
                            style: const TextStyle(color: Colors.black),
                            controller: passwordController,
                            obscureText: mqttController.fanPass.value,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  mqttController.fanPass.value =
                                      !mqttController.fanPass.value;
                                },
                                icon: Icon(
                                  mqttController.fanPass.value
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye,
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Enter Password".tr,
                              hintStyle: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              "cancel".tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final enteredPassword =
                                  passwordController.text.trim();

                              if (enteredPassword == '1234') {
                                mqttController.fancontrol.value = false;
                                mqttController.updateFanAutomation(false);
                                log("Fan mode changed to: Manual");
                                Get.back();
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Incorrect password',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: Text(
                              "Submit".tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                } else {
                  mqttController.fancontrol.value = true;
                  mqttController.updateFanAutomation(true);
                  log("Fan mode changed to: Auto");
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
                            mqttController.toggleSwitchf(0);
                            await Future.delayed(Duration(milliseconds: 500));
                            return !isOn;
                          },
                          onChange: (_) {},
                          onTap: (val) {
                            log("fan switch change : $val");
                          },
                          animationDuration: const Duration(milliseconds: 500),
                          curveIn: Curves.easeInBack,
                          curveOut: Curves.easeOutBack,
                          style: SpinStyle.material,
                          switchDecoration: (value, loading) {
                            final isAuto = mqttController.fancontrol.value;
                            return BoxDecoration(
                              color: isAuto
                                  ? const Color(0xFF24C48E).withOpacity(0.3)
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
                            final isAuto = mqttController.fancontrol.value;
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
                              mqttController.fancontrol.value;

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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    "Enter Password".tr,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  content: Obx(
                                    () => TextField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: passwordController,
                                      obscureText: mqttController.fanPass.value,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            mqttController.fanPass.value =
                                                !mqttController.fanPass.value;
                                          },
                                          icon: Icon(
                                            mqttController.fanPass.value
                                                ? Icons.visibility_off
                                                : Icons.remove_red_eye,
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Enter Password".tr,
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        "cancel".tr,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final enteredPassword =
                                            passwordController.text.trim();

                                        if (enteredPassword == '1234') {
                                          mqttController.fancontrol.value =
                                              false;
                                          mqttController
                                              .updateFanAutomation(false);
                                          log("Fan mode changed to: Manual");
                                          Get.back();
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Incorrect password',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Submit".tr,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          } else {
                            mqttController.fancontrol.value = true;
                            mqttController.updateFanAutomation(true);
                            log("Fan mode changed to: Auto");
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
                      'fan_controller'.tr,
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
          Obx(() {
            bool isOn = mqttController.pumpSwitch.value;
            bool isAuto = mqttController.pumpcontrol.value;
            return GestureDetector(
              onTap: () async {
                if (!isAuto) {
                  mqttController.toggleSwitch(1);
                  await Future.delayed(Duration(milliseconds: 500));
                  mqttController.pumpSwitch.value = !isOn;
                }
              },
              onLongPress: () {
                final isCurrentlyAuto = mqttController.pumpcontrol.value;
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
                                mqttController.pumpcontrol.value = false;
                                mqttController.updatePumpAutomation(false);
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
                  mqttController.pumpcontrol.value = true;
                  mqttController.updatePumpAutomation(true);
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
                            mqttController.toggleSwitch(1);
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
                            final isAuto = mqttController.pumpcontrol.value;
                            return BoxDecoration(
                              color: isAuto
                                  ? const Color(0xFF24C48E).withOpacity(0.3)
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
                            final isAuto = mqttController.pumpcontrol.value;
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
                              mqttController.pumpcontrol.value;
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
                                          mqttController.pumpcontrol.value =
                                              false;
                                          mqttController
                                              .updatePumpAutomation(false);
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
                            mqttController.pumpcontrol.value = true;
                            mqttController.updatePumpAutomation(true);
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
