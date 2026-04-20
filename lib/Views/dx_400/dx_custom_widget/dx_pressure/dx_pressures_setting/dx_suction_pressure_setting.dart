import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxSuctionPressureSetting extends StatelessWidget {
  final MqttController _mqttController = Get.find<MqttController>();

  DxSuctionPressureSetting({super.key});

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
    Timer? publishTimer;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'suction_pressure_setting'.tr,
            style: TextStyle(
              color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
              fontSize: getResponsiveFontSize(screenWidth, 0.06),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        progressBarColors: [
                          Color(0xFF24C48E),
                          Color(0xFF24C456)
                        ],
                        dotColor: Color(0xFF24C48E),
                      ),
                    ),
                    min: 0,
                    max: 300,
                    initialValue: _mqttController.dxpsig1sethigh.value
                        .toDouble()
                        .clamp(0, 300),
                    onChangeStart: (_) =>
                        _mqttController.isUserInteracting.value = true,
                    onChange: (value) {
                      _mqttController.isUserInteracting.value = true;
                      _mqttController.updatedxLowPressurelp(value);
                    },
                    onChangeEnd: (_) {  
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 1), () {
                        _mqttController.dxbuildJsonPayload();
                        log("build");

                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.isUserInteracting.value = false;
                          log("Start");
                        });
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
                                  ? ThemeColor().actual.withOpacity(0.8)
                                  : Colors.black26,
                              blurRadius: 20,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _mqttController.dxpsig1sethigh.value
                                  .toDouble()
                                  .toStringAsFixed(0),
                              style: TextStyle(
                                fontFamily: 'DS-Digital',
                                fontSize:
                                    getResponsiveFontSize(screenWidth, 0.14),
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              "PSI",
                              style: TextStyle(
                                fontFamily: 'DS-Digital',
                                fontSize:
                                    getResponsiveFontSize(screenWidth, 0.08),
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: baseSize * 0.03),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _mqttController.isUserInteracting.value = true;

                            if (_mqttController.dxpsig1sethigh.value > 0) {
                              _mqttController.dxpsig1sethigh.value -= 1;
                              publishTimer?.cancel();
                              _mqttController.updatedxLowPressurelp(
                                  _mqttController.dxpsig1sethigh.value
                                      .toDouble());
                              publishTimer = Timer(Duration(seconds: 1), () {
                                _mqttController.buildJsonPayload();
                                _mqttController.isUserInteracting.value = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                            padding: EdgeInsets.symmetric(
                                horizontal: shortestSide * 0.12,
                                vertical: baseSize * 0.001),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: const Color(0xFF24C48E),
                            // size: (screenWidth * 0.06).clamp(20.0, 30.0),
                          ),
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
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _mqttController.isUserInteracting.value = true;

                            if (_mqttController.dxpsig1sethigh.value < 300) {
                              _mqttController.dxpsig1sethigh.value += 1;
                              publishTimer?.cancel();
                              _mqttController.updatedxLowPressurelp(
                                  _mqttController.dxpsig1sethigh.value
                                      .toDouble());
                              publishTimer = Timer(Duration(seconds: 1), () {
                                _mqttController.buildJsonPayload();
                                _mqttController.isUserInteracting.value = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                            padding: EdgeInsets.symmetric(
                                horizontal: shortestSide * 0.12,
                                vertical: baseSize * 0.001),
                          ),
                          child: Icon(
                            Icons.add,
                            color: const Color(0xFF24C48E),
                            // size: (screenWidth * 0.06).clamp(20.0, 30.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
