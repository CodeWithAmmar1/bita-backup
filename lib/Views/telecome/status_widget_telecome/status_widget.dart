import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/telecome/status_widget_telecome/status_setting/status_screen.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class StatusWidget extends StatelessWidget {
  final RxBool isReturn = true.obs;
  final String deviceId;
  StatusWidget({super.key, required this.deviceId});
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.02),
      child: Container(
        width: Get.width * 0.95,
        padding: EdgeInsets.all(Get.width * 0.03),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          borderRadius: BorderRadius.circular(Get.width * 0.03),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stay_current_landscape_rounded,
                          color: Colors.red, size: Get.width * 0.07),
                      SizedBox(width: Get.width * 0.015),
                      Text(
                        "ac_units_status".tr,
                        style: TextStyle(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => StatusScreen());
                    },
                    child: Icon(
                      Icons.settings,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      size: Get.width * 0.065,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            Obx(
              () => Row(
                children: [
                  Expanded(
                      child: StatusCard(
                    textColor: _mqttController.unitOneTel.value == 1
                        ? Colors.green
                        : Colors.red,
                    title: "ac_unit_1".tr,
                    status: _mqttController.deviceConnections[deviceId] ?? false
                        ? _mqttController.unitOneTel.value == 1
                            ? "on".tr
                            : _mqttController.unitOneTel.value == 0
                                ? "off".tr
                                : "--"
                        : "--",
                  )),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                      child: StatusCard(
                    textColor: _mqttController.unitTwoTel.value == 1
                        ? Colors.green
                        : Colors.red,
                    title: "ac_unit_2".tr,
                    status: _mqttController.deviceConnections[deviceId] ?? false
                        ? _mqttController.unitTwoTel.value == 1
                            ? "on".tr
                            : _mqttController.unitTwoTel.value == 0
                                ? "off".tr
                                : "--"
                        : "--",
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final Color textColor;

  const StatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final media = Get.mediaQuery;
    final width = media.size.width;
    final height = media.size.height;

    final size = width < height ? width : height;
    final cardWidth = size * 0.45;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? ThemeColor().mode2Sec
                    : ThemeColor().mode1Sec,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Get.isDarkMode ? Colors.white : Colors.black,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      "assets/images/ac.png",
                      width: size * 0.2,
                      height: size * 0.15,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? ThemeColor().mode2Sec
                    : ThemeColor().mode1Sec,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size * 0.045,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
