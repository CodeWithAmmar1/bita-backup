import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxSeasonsheet extends StatelessWidget {
  final MqttController _mqttcontroller = Get.find();

  DxSeasonsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: Get.width,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Color(0xFF121212) : ThemeColor().mode1Sec,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'mode'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'heating'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Obx(() => LoadSwitch(
                    height: Get.height * 0.048,
                    width: Get.height * 0.09,
                    value: _mqttcontroller.isSummer.value,
                    future: () async {
                      _mqttcontroller.isSeasonLoading.value = true;
                      final newValue = !_mqttcontroller.isSummer.value;

                      await _mqttcontroller.selectSeasonDx(newValue);
                      _mqttcontroller.isSeasonLoading.value = false;
                      return newValue;
                    },
                    onChange: (_) {},
                    onTap: (val) {
                      log("Tapped while value is $val");
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
                      boxShadow: [
                        BoxShadow(
                          color: value
                              ? ThemeColor().actual.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    spinColor: (value) => value
                        ? ThemeColor().actual
                        : const Color.fromARGB(255, 255, 77, 77),
                    spinStrokeWidth: 3,
                    thumbDecoration: (value, loading) => BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: value
                              ? ThemeColor().actual.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              Text(
                "cooling".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
