import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class TemperatureContainercsm extends StatelessWidget {
  final String unit;
  final String heading;
  final IconData icon;
  final RxDouble value;

  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  TemperatureContainercsm(
      {super.key,
      required this.deviceId,
      required this.unit,
      required this.heading,
      required this.icon,
      required this.value});
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
                    Icon(icon, color: Colors.red, size: Get.width * 0.07),
                    SizedBox(width: Get.width * 0.015),
                    Text(
                      heading,
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
                  child: TempWidget(
                    temperature:
                        _mqttController.deviceConnections[deviceId] ?? false
                            ? "${value.value}$unit"
                            : "--.-",
                    getColorLogic: () =>
                        value.value >= _mqttController.tempcsmSp.value
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

class HumidityContainercsm extends StatelessWidget {
  final String unit;
  final String heading;
  final IconData icon;
  final RxString value;
  final String status;
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  HumidityContainercsm(
      {super.key,
      required this.deviceId,
      required this.unit,
      required this.heading,
      required this.icon,
      required this.value,
      required this.status});
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
                    Icon(icon, color: Colors.red, size: Get.width * 0.07),
                    SizedBox(width: Get.width * 0.015),
                    Text(
                      heading,
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
                  child: TempWidget(
                    temperature:
                        _mqttController.deviceConnections[deviceId] ?? false
                            ? "${value.value}$unit"
                            : status,
                    getColorLogic: () =>
                        Get.isDarkMode ? Colors.white : Colors.black,
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

class TempWidget extends StatelessWidget {
  final String temperature;
  final Color Function()? getColorLogic;

  const TempWidget({
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
