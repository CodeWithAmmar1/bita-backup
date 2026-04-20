import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/water_tank_control/wtcWaterLevel/wtc_water_tank.dart';
import 'package:testappbita/controller/water_controller/water_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Wtcwaterlevel extends StatelessWidget {
  final WaterLevelController controller = Get.put(WaterLevelController());

  Wtcwaterlevel({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          border: Border.all(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(shortestSide * 0.04),
        ),
        width: shortestSide * 0.94,
        height: baseSize * 0.25,
        padding: EdgeInsets.all(shortestSide * 0.05),
        child: Stack(
          children: [
            Positioned(
              top: baseSize * 0.005,
              left: shortestSide * 0.08,
              child: Container(
                width: shortestSide * 0.2,
                height: baseSize * 0.15,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/water-tank.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: shortestSide * 0.2,
              child: SizedBox(
                height: baseSize * 0.16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTextLabel("${'hi'.tr}-", context),
                    _buildTextLabel("${'low'.tr}-", context),
                  ],
                ),
              ),
            ),
            WtcWaterTank(),
            Positioned(
              bottom: baseSize * 0.00009,
              left: shortestSide * 0.075,
              child: Text(
                'waterTank'.tr,
                style: TextStyle(
                  fontSize: shortestSide * 0.04,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Positioned(
              bottom: baseSize * 0.00009,
              right: shortestSide * 0.03,
              child: Text(
                'water_level'.tr,
                style: TextStyle(
                  fontSize: shortestSide * 0.04,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text, context) {
    final media = MediaQuery.of(context);
    final shortestSide = media.size.shortestSide;
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: shortestSide * 0.03,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
