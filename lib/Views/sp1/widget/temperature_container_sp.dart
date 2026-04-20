import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class TemperatureContainerSp extends StatelessWidget {
  final RxBool isReturn = true.obs;
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  TemperatureContainerSp({super.key, required this.deviceId});
  @override
  Widget build(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.thermostat,
                        color: Colors.red, size: Get.width * 0.07),
                    SizedBox(width: Get.width * 0.015),
                    Text(
                      'Current Temperature'.tr,
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.015),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: TemperatureWidgetSp(
                    temperature:
                        _mqttController.deviceConnections[deviceId] ?? false
                            ? _mqttController.tempsp.value == 999.0
                                ? "--.-"
                                : "${_mqttController.tempsp.value}°C"
                            : "--",
                    getColorLogic: () => _mqttController.tempsp.value >=
                            _mqttController.tempSetPointsp.value
                        ? Colors.red
                        : Get.isDarkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TemperatureWidgetSp extends StatelessWidget {
  final String temperature;
  final Color Function()? getColorLogic;

  const TemperatureWidgetSp({
    required this.temperature,
    super.key,
    this.getColorLogic,
  });

  @override
  Widget build(BuildContext context) {
    final tempColor = getColorLogic != null ? getColorLogic!() : Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.015,
        horizontal: Get.width * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.width * 0.02),
        color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      ),
      child: Text(
        temperature.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'DS-Digital',
          fontSize: Get.height * 0.07,
          fontWeight: FontWeight.bold,
          color: tempColor,
        ),
      ),
    );
  }
}
