import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class CustomBottomSheet1 extends StatelessWidget {
  final MqttController _mqttcontroller = Get.find();
  CustomBottomSheet1({super.key});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: SizedBox(
        height: baseSize * 0.29,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: baseSize * 0.197,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Get.isDarkMode ? Colors.white : Colors.black,
                                BlendMode.srcIn),
                            child: Image.asset(
                              "assets/images/damper_vertical.png",
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("supply_cfm".tr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                _mqttcontroller.currentValue.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape:
                                  _mqttcontroller.isPasswordCorrect.value
                                      ? const RoundSliderThumbShape(
                                          enabledThumbRadius: 10.0,
                                        )
                                      : SliderComponentShape.noThumb,
                            ),
                            child: Slider(
                              activeColor: ThemeColor().actual,
                              value: _mqttcontroller.currentValue.value,
                              min: 10,
                              max: 100,
                              divisions: 100,
                              label: _mqttcontroller.currentValue
                                  .toStringAsFixed(0),
                              onChanged: _mqttcontroller.isPasswordCorrect.value
                                  ? (double value) {
                                      _mqttcontroller.isUserInteracting.value =
                                          true;
                                      _mqttcontroller.currentValue.value =
                                          double.parse(
                                              value.toStringAsFixed(0));
                                      _mqttcontroller.startLockTimer();
                                    }
                                  : null,
                              onChangeEnd: _mqttcontroller
                                      .isPasswordCorrect.value
                                  ? (double value) {
                                      publishTimer?.cancel();
                                      publishTimer =
                                          Timer(Duration(seconds: 1), () {
                                        String message =
                                            _mqttcontroller.createjson();
                                        _mqttcontroller.publishMessage(message);
                                        publishTimer =
                                            Timer(Duration(seconds: 1), () {
                                          _mqttcontroller
                                              .isUserInteracting.value = false;
                                        });
                                      });
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => Text(
                  _mqttcontroller.isPasswordCorrect.value
                      ? 'enable'.tr
                      : "disable".tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _mqttcontroller.isPasswordCorrect.value
                          ? ThemeColor().actual
                          : Get.isDarkMode
                              ? Colors.grey
                              : Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
