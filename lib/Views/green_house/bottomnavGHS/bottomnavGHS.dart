import 'dart:async';

import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Bottomnavghs extends StatelessWidget {
  Bottomnavghs({super.key});
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
        mainAxisAlignment: MainAxisAlignment.center,
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
                        mqttController.ghsPower.value =
                            !mqttController.ghsPower.value;
                      },
                      child: LoadSwitch(
                        height: baseSize * 0.055,
                        width: baseSize * 0.055,
                        value: mqttController.ghsPower.value,
                        future: () async {
                          final newValue = !mqttController.ghsPower.value;
                          mqttController.ghsPower.value = newValue;
                          mqttController.isUserInteracting.value = true;
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            mqttController.updateGhsPower(newValue);
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
                          color: mqttController.ghsPower.value
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
        ],
      ),
    );
  }
}
