import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/amperes/ampere_settings/ampere_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class AmpereContainer extends StatelessWidget {
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();

  AmpereContainer({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_mqttController.isAmpVisible.value) {
        return SizedBox();
      }
      return Padding(
        padding: EdgeInsets.all(Get.width * 0.02),
        child: Container(
          width: Get.width * 0.95,
          padding: EdgeInsets.all(Get.width * 0.03),
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.electric_bolt,
                          color: Colors.red, size: Get.width * 0.07),
                      SizedBox(width: Get.width * 0.015),
                      Text(
                        'compressorCurrent'.tr,
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
                        Get.to(() => AmpereSetting());
                      },
                      child: Icon(Icons.settings,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: Get.width * 0.065)),
                ],
              ),
              SizedBox(height: Get.height * 0.015),
              Obx(() => Row(
                    children: [
                      Expanded(
                          child: AmpereWidget(
                              title: 'phase_1'.tr,
                              ampere:
                                  _mqttController.deviceConnections[deviceId] ??
                                          false
                                      ? _mqttController.amp2.value.toString()
                                      : "--")),
                      SizedBox(width: Get.width * 0.015),
                      Expanded(
                          child: AmpereWidget(
                              title: 'phase_2'.tr,
                              ampere:
                                  _mqttController.deviceConnections[deviceId] ??
                                          false
                                      ? _mqttController.amp3.value.toString()
                                      : "--")),
                      SizedBox(width: Get.width * 0.015),
                      Expanded(
                          child: AmpereWidget(
                              title: 'phase_3'.tr,
                              ampere:
                                  _mqttController.deviceConnections[deviceId] ??
                                          false
                                      ? _mqttController.amp1.value.toString()
                                      : "--")),
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}

class AmpereWidget extends StatelessWidget {
  final String title;
  final String ampere;
  final MqttController _mqttController = Get.find<MqttController>();

  AmpereWidget({
    required this.title,
    required this.ampere,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.012,
        horizontal: Get.width * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.width * 0.025),
        color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.040,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: Get.height * 0.005),
          Obx(() {
            final int? ampValue = int.tryParse(ampere);
            final int lowLimit = _mqttController.amp1low.value;

            Color ampColor = (ampValue != null && ampValue >= lowLimit)
                ? Colors.red
                : Get.isDarkMode
                    ? Colors.white
                    : Colors.black;

            return Text(
              ampere,
              style: TextStyle(
                fontSize: Get.width * 0.042,
                fontWeight: FontWeight.bold,
                color: ampColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}
