import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SetpointWidgetRcm extends StatelessWidget {
  final String title;
  final String unit;
  final int minValue;
  final int maxValue;
  final RxInt value;

  final VoidCallback onPublish;

  SetpointWidgetRcm({
    super.key,
    required this.title,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onPublish,
  });

  final MqttController _mqttController = Get.find<MqttController>();

  double getResponsiveFontSize(double screenWidth, double baseSize) {
    return (screenWidth * baseSize).clamp(16.0, 40.0);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Timer? publishTimer;

    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: getResponsiveFontSize(media.size.width, 0.06),
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                SizedBox(height: 95),
                SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    size: baseSize * 0.35,
                    angleRange: 260,
                    startAngle: 140,
                    customWidths: CustomSliderWidths(
                      trackWidth: baseSize * 0.008,
                      progressBarWidth: baseSize * 0.008,
                      handlerSize: baseSize * 0.015,
                    ),
                    customColors: CustomSliderColors(
                      trackColor: Colors.grey[500],
                      progressBarColors: [Color(0xFF24C48E), Color(0xFF24C456)],
                      dotColor: Color(0xFF24C48E),
                    ),
                  ),
                  min: minValue.toDouble(),
                  max: maxValue.toDouble(),
                  initialValue:
                      value.value.clamp(minValue, maxValue).toDouble(),
                  onChangeStart: (_) {
                    _mqttController.isUserInteracting.value = true;
                  },
                  onChange: (v) {
                    value.value = v.toInt();
                  },
                  onChangeEnd: (_) {
                    publishTimer?.cancel();
                    publishTimer = Timer(const Duration(seconds: 1), () {
                      onPublish();
                      _mqttController.isUserInteracting.value = false;
                    });
                  },
                  innerWidget: (_) => Center(
                    child: Container(
                      width: baseSize * 0.56,
                      height: baseSize * 0.28,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                        boxShadow: [
                          BoxShadow(
                            color: Get.isDarkMode
                                ? ThemeColor().actual.withValues(alpha: 0.8)
                                : Colors.black26,
                            blurRadius: 20,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          value.value.toStringAsFixed(0),
                          style: TextStyle(
                            fontFamily: 'DS-Digital',
                            fontSize: getResponsiveFontSize(screenWidth, 0.14),
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(
                      screenWidth: screenWidth,
                      baseSize: baseSize,
                      shortestSide: shortestSide,
                      icon: Icons.remove,
                      onTap: () {
                        if (value.value > minValue) {
                          value.value--;
                          _mqttController.isUserInteracting.value = true;
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            onPublish();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.isUserInteracting.value = false;
                            });
                          });
                        }
                      },
                    ),
                    Container(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      width: shortestSide * 0.28,
                      height: baseSize * 0.05,
                      child: Center(
                        child: Text(
                          'Set Point'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    _actionButton(
                      screenWidth: screenWidth,
                      baseSize: baseSize,
                      shortestSide: shortestSide,
                      icon: Icons.add,
                      onTap: () {
                        if (value.value < maxValue) {
                          value.value++;
                          _mqttController.isUserInteracting.value = true;
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            onPublish();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.isUserInteracting.value = false;
                            });
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
      {required IconData icon,
      required double shortestSide,
      required double baseSize,
      required double screenWidth,
      required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        padding: EdgeInsets.symmetric(
            horizontal: shortestSide * 0.12, vertical: baseSize * 0.001),
      ),
      child: Icon(
        icon,
        color: ThemeColor().actual,
        size: (screenWidth * 0.06).clamp(20.0, 30.0),
      ),
    );
  }
}