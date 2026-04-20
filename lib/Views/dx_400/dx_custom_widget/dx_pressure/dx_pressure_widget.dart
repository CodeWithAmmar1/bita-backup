import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxPressureWidget extends StatelessWidget {
  final String title;
  final String setpoint;
  final String? high;
  final String? low;
  final Color Function(double pressure)? getColorLogic;
  final int limit;
  const DxPressureWidget({
    super.key,
    required this.title,
    required this.setpoint,
    this.high,
    this.low,
    this.getColorLogic,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    double pressure = double.parse(setpoint);
    Color pressureColor =
        getColorLogic != null ? getColorLogic!(pressure) : Colors.white;
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: shortestSide * 0.42,
        height: isPortrait ? baseSize * 0.21 : baseSize * 0.22,
        // height: 160,
        // width: 160,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
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
                SizedBox(
                  height: shortestSide * 0.14,
                  width: shortestSide * 0.14,
                  // height: 50,
                  // width: 50,
                  child: CircularProgressIndicator(
                    value: (double.parse(setpoint) / limit),
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[500],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF24C456)),
                  ),
                ),
                Text(
                  "${(double.parse(setpoint)).toInt()}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: pressureColor,
                  ),
                ),
              ],
            ),
            // SizedBox(height: baseSize * 0.03),
            const Spacer(),

            if (low != null || high != null)
              Container(
                width: shortestSide * 1,
                height: baseSize * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ThemeColor().actual,
                ),
                child: Row(
                  mainAxisAlignment: (low != null && high != null)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    if (low != null)
                      Row(
                        children: [
                          Text('${'low'.tr}: ',
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          Text(low!,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 13)),
                        ],
                      ),
                    if (high != null)
                      Row(
                        children: [
                          Text('${'high'.tr}: ',
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          Text(high!,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 13)),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
