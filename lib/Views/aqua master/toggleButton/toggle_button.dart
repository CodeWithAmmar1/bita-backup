import 'dart:async';
import 'dart:developer';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/aqua%20master/dailog/pass_dailog.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class ThreeModeToggle extends StatefulWidget {
  final RxInt mode;
  final String label;
  final Function(int) onChanged;
  const ThreeModeToggle({
    super.key,
    required this.mode,
    required this.label,
    required this.onChanged,
  });

  @override
  State<ThreeModeToggle> createState() => _ThreeModeToggleState();
}

class _ThreeModeToggleState extends State<ThreeModeToggle> {
  final MqttController mqttController = Get.find<MqttController>();
  Timer? publishTimer;

  @override
  void initState() {
    super.initState();

    ever(mqttController.modeAqm, (bool isAqm) {
      if (!isAqm && (widget.mode.value == 2 || widget.mode.value == 0)) {
        widget.mode.value = 1;
      }
    });
  }

  void _handleToggleChange(int val) async {
    if ((val == 0 || val == 1) &&
        widget.mode.value != val &&
        mqttController.modeAqm.value) {
      Get.defaultDialog(
        title: 'Enter Password'.tr,
        content: PasscodeDialog(
          onPasscodeEntered: (passcode) {
            if (passcode == '1234') {
              Get.back();
              Future.delayed(Duration(milliseconds: 200), () {
                mqttController.isUserInteracting.value = true;
                publishTimer?.cancel();
                publishTimer = Timer(Duration(seconds: 1), () {
                  log("Toggle value changed:");
                  widget.mode.value = val;
                  widget.onChanged(val);
                  publishTimer = Timer(Duration(seconds: 1), () {
                    log("start publish");
                    mqttController.isUserInteracting.value = false;
                  });
                });
              });
            } else {
              Get.snackbar('error'.tr, 'wrong_password'.tr,
                  backgroundColor: Colors.redAccent, colorText: Colors.white);
            }
          },
        ),
      );
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      mqttController.isUserInteracting.value = true;
      publishTimer?.cancel();
      log("Toggle value changed:");
      widget.mode.value = val;
      publishTimer = Timer(Duration(seconds: 1), () {
        widget.onChanged(val);
        log("start publish");
        mqttController.isUserInteracting.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => AnimatedToggleSwitch<int>.rolling(
                  current: widget.mode.value,
                  values: mqttController.modeAqm.value ? [0, 1, 2] : [0, 1],
                  onChanged: _handleToggleChange,
                  iconBuilder: (value, size) {
                    final labels = mqttController.modeAqm.value
                        ? ['On', 'Off', 'Auto']
                        : ['On', 'Off'];
                    return Center(
                      child: Text(
                        labels[value],
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                  style: ToggleStyle(
                    borderColor: ThemeColor().actual,
                    indicatorColor: ThemeColor().actual,
                    backgroundColor: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 50,
                  spacing: 4.0,
                )),
          ],
        ),
      ),
    );
  }
}
