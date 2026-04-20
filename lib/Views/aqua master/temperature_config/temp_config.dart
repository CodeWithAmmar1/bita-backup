import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TempConfig extends StatefulWidget {
  const TempConfig({super.key});

  @override
  State<TempConfig> createState() => _TempConfigState();
}

Timer? publishTimer;

class _TempConfigState extends State<TempConfig> {
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  /// 🔹 Fixed headings
  final List<String> headings = [
    'boiler',
    'cooler_comfort',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColor().actual,
        title: Text(
          'tempSensorsConfig'.tr,
          style: TextStyle(
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.01),
            for (int i = 0; i < 2; i++) ...[
              _buildSensorBox(i, textColor, isDark),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSensorBox(int index, Color textColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Sensor + temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '${'sensor'.tr} ${index + 1}',
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Obx(() {
                  final temps = [
                    _mqttController.sensorAquaTemp1.value,
                    _mqttController.sensorAquaTemp2.value,
                  ];
                  return Text(
                    '${'temp'.tr} ${double.parse(temps[index]).toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontSize: Get.width * 0.04,
                      color: textColor,
                    ),
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 🔹 Heading + offset controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  headings[index].tr,
                  style: TextStyle(
                    color: ThemeColor().actual,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              Row(
                children: [
                  Text('offset'.tr, style: TextStyle(color: textColor)),
                  IconButton(
                    icon: Icon(Icons.remove, color: textColor),
                    onPressed: () {
                      _mqttController.isUserInteracting.value = true;
                      controller.changeOffsetAQM(index, -1);
                      _resetPublishTimer();
                    },
                  ),
                  Obx(() {
                    final offsets = [
                      int.tryParse(_mqttController.offset1Aqua.value) ?? 0,
                      int.tryParse(_mqttController.offset2Aqua.value) ?? 0,
                    ];
                    return Text(
                      '${offsets[index]}°C',
                      style: TextStyle(color: textColor),
                    );
                  }),
                  IconButton(
                    icon: Icon(Icons.add, color: textColor),
                    onPressed: () {
                      _mqttController.isUserInteracting.value = true;
                      controller.changeOffsetAQM(index, 1);
                      _resetPublishTimer();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Shared publish logic
  void _resetPublishTimer() {
    publishTimer?.cancel();
    publishTimer = Timer(const Duration(seconds: 1), () {
      _mqttController.buildJsonPayloadAQMSensor();
      publishTimer = Timer(const Duration(seconds: 1), () {
        _mqttController.isUserInteracting.value = false;
      });
    });
  }
}
