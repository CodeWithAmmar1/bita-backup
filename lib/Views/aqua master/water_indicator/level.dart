import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/aqua%20master/water_indicator/water_tank.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/water_controller/water_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class WaterLevelContainer extends StatelessWidget {
  final String deviceid;
  final WaterLevelController controller = Get.put(WaterLevelController());
  final MqttController mqttController = Get.find<MqttController>();
  WaterLevelContainer({super.key, required this.deviceid});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0,),
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          border: Border.all(
            color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(shortestSide * 0.04),
        ),
        width: shortestSide * 0.94,
        height: baseSize * 0.26,
        padding: EdgeInsets.all(shortestSide * 0.02),
        child: Stack(
          children: [
            WaterTank(),
            Positioned(
              bottom: baseSize * 0.000001,
              right: shortestSide * 0.15,
              child: Obx(
                () => Row(
                  children: [
                    Text(
                      '${'overhead_tank_water_level'.tr} - ',
                      style: TextStyle(
                        fontSize: shortestSide * 0.04,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      mqttController.deviceConnections[deviceid] ?? false
                          ? mqttController.userSetValue.value == 1
                              ? 'hi'.tr
                              : 'low'.tr
                          : "--",
                      style: TextStyle(
                        fontSize: shortestSide * 0.04,
                        fontWeight: FontWeight.bold,
                        color: mqttController.userSetValue.value == 1
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
