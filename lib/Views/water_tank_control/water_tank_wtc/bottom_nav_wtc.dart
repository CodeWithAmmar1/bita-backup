import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class BottomNavWtc extends StatelessWidget {
  BottomNavWtc({super.key});
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
          SizedBox(
            width: 25,
          ),
          Obx(() {
            bool isOn = mqttController.wtcfanSwitch.value;
            bool isAuto = mqttController.wtcfancontrol.value;
            return GestureDetector(
              onTap: () async {
                if (!isAuto) {
                  mqttController.wtctoggleSwitchf(0);
                  await Future.delayed(Duration(milliseconds: 500));
                  mqttController.wtcfanSwitch.value = !isOn;
                }
              },
              onLongPress: () {
                final isCurrentlyAuto = mqttController.wtcfancontrol.value;
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
                            obscureText: mqttController.wtcfanPass.value,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  mqttController.wtcfanPass.value =
                                      !mqttController.wtcfanPass.value;
                                },
                                icon: Icon(
                                  mqttController.wtcfanPass.value
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
                                mqttController.wtcfancontrol.value = false;
                                mqttController.wtcupdateFanAutomation(false);
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
                  mqttController.wtcfancontrol.value = true;
                  mqttController.wtcupdateFanAutomation(true);
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
                            mqttController.wtctoggleSwitchf(0);
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
                            final isAuto = mqttController.wtcfancontrol.value;
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
                            final isAuto = mqttController.wtcfancontrol.value;
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
                              mqttController.wtcfancontrol.value;

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
                                      obscureText:
                                          mqttController.wtcfanPass.value,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            mqttController.wtcfanPass.value =
                                                !mqttController
                                                    .wtcfanPass.value;
                                          },
                                          icon: Icon(
                                            mqttController.wtcfanPass.value
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
                                          mqttController.wtcfancontrol.value =
                                              false;
                                          mqttController
                                              .wtcupdateFanAutomation(false);
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
                            mqttController.wtcfancontrol.value = true;
                            mqttController.wtcupdateFanAutomation(true);
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
          SizedBox(
            width: 10,
          ),
          Obx(() => GestureDetector(
                onTap: () {
                  mqttController.showDayAndHourPicker(
                    context,
                    "system_operation_scheduling".tr,
                    onUpdated: () => mqttController.wtcsendData(
                        Map<String, dynamic>.from(
                            mqttController.wtcreceivedData)),
                  );
                },
                child: _buildIconContainer(
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
          SizedBox(
            width: 10,
          ),
          Obx(() {
            bool isOn = mqttController.wtcpumpSwitch.value;
            bool isAuto = mqttController.wtcpumpcontrol.value;
            return GestureDetector(
              onTap: () async {
                if (!isAuto) {
                  mqttController.wtctoggleSwitch(1);
                  await Future.delayed(Duration(milliseconds: 500));
                  mqttController.wtcpumpSwitch.value = !isOn;
                }
              },
              onLongPress: () {
                final isCurrentlyAuto = mqttController.wtcpumpcontrol.value;
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
                            obscureText: mqttController.wtcpumpPass.value,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    mqttController.wtcpumpPass.value =
                                        !mqttController.wtcpumpPass.value;
                                  },
                                  icon: mqttController.wtcpumpPass.value
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
                                mqttController.wtcpumpcontrol.value = false;
                                mqttController.wtcupdatePumpAutomation(false);
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
                  mqttController.wtcpumpcontrol.value = true;
                  mqttController.wtcupdatePumpAutomation(true);
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
                            mqttController.wtctoggleSwitch(1);
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
                            final isAuto = mqttController.wtcpumpcontrol.value;
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
                            final isAuto = mqttController.wtcpumpcontrol.value;
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
                              mqttController.wtcpumpcontrol.value;
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
                                          mqttController.wtcpumpPass.value,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              mqttController.wtcpumpPass.value =
                                                  !mqttController
                                                      .pumpPass.value;
                                            },
                                            icon:
                                                mqttController.wtcpumpPass.value
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
                                          mqttController.wtcpumpcontrol.value =
                                              false;
                                          mqttController
                                              .wtcupdatePumpAutomation(false);
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
                            mqttController.wtcpumpcontrol.value = true;
                            mqttController.wtcupdatePumpAutomation(true);
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
                  ),
                ],
              ),
            );
          }),
          SizedBox(
            width: 18,
          )
        ],
      ),
    );
  }
}

Widget _buildIconContainer(
  BuildContext context,
  IconData icon,
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
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        children: [
          Container(
            height: baseSize * 0.055,
            width: baseSize * 0.067,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(icon, color: iconColor),
          ),
          if (showTick)
            Positioned(
              bottom: -1,
              right: -1,
              child: Icon(
                Icons.check_circle,
                color: tickColor,
                size: 18,
              ),
            ),
        ],
      ),
      Padding(
        padding: EdgeInsets.all(shortestSide * 0.009),
        child: Text(
          text.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: shortestSide * 0.030,
            color: txtcolor,
          ),
        ),
      ),
    ],
  );
}
