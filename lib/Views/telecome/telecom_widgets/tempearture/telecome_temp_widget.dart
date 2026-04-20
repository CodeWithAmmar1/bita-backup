import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'dart:math' as math;

class TelecomeTempWidget extends StatelessWidget {
  final String title;
  final String setpoint;
  final String high;
  final int limit;
  final String unit;
  final Color Function(int temp)? getColorLogic;
  const TelecomeTempWidget({
    super.key,
    required this.title,
    required this.setpoint,
    required this.high,
    this.getColorLogic,
    required this.limit,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    int temp = int.parse(setpoint);
    int high = int.parse(setpoint);
    Color pressureColor =
        getColorLogic != null ? getColorLogic!(temp) : Colors.white;
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: shortestSide * 0.42,
          height: isPortrait ? baseSize * 0.21 : baseSize * 0.22,
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: baseSize * 0.020,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: baseSize * 0.021),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: math.pi, // ⬅️ start from bottom
                    child: SizedBox(
                      height: shortestSide * 0.14,
                      width: shortestSide * 0.14,
                      child: CircularProgressIndicator(
                        value: (double.parse(setpoint) / limit),
                        strokeWidth: 4,
                        backgroundColor: Colors.grey[500],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF24C456),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${(double.parse(setpoint)).toInt()}$unit",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: pressureColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ThemeColor().actual,
                ),
                width: shortestSide * 1,
                height: baseSize * 0.05,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${"setPoint".tr} $high",
                        style: TextStyle(
                          fontSize: baseSize * 0.016,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
