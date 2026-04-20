import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/drain_master/water_level/watertankDrain.dart';
import 'package:testappbita/controller/water_controller/water_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DrainwaterLevel extends StatelessWidget {
  final String title;
  final WaterLevelController controller = Get.put(WaterLevelController());

  DrainwaterLevel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
        borderRadius: BorderRadius.circular(shortestSide * 0.04),
      ),
      width: shortestSide * 0.94,
      height: baseSize * 0.25,
      padding: EdgeInsets.only(
          left: shortestSide * 0.02,
          right: shortestSide * 0.02,
          top: shortestSide * 0.05,
          bottom: shortestSide * 0.05),
      child: Stack(
        children: [
          Positioned(
            right: shortestSide * 0.7,
            child: SizedBox(
              height: baseSize * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextLabel("${'OVERFLOW'.tr}-", context),
                  _buildTextLabel("${'hi'.tr}-", context),
                  _buildTextLabel("${'EMPTY'.tr}-", context),
                ],
              ),
            ),
          ),
          Watertankdrain(),
          Positioned(
            bottom: baseSize * 0.05,
            right: shortestSide * 0.24,
            child: Text(
              'Condenset Water Tray'.tr,
              style: TextStyle(
                fontSize: shortestSide * 0.04,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
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
