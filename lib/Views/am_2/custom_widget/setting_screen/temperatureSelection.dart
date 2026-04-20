import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Temperatureselection extends StatefulWidget {
  const Temperatureselection({super.key});

  @override
  State<Temperatureselection> createState() => _TemperatureselectionState();
}

Timer? publishTimer;

class _TemperatureselectionState extends State<Temperatureselection> {
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  final List<String> headings = [
    'suction',
    'discharge',
    'return',
    'supply',
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
          'tempSensorsSetting'.tr,
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
            for (int i = 0; i < 4; i++) ...[
              _buildSensorBox(i, controller, textColor, isDark),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSensorBox(
      int index, SensorSwitchController ctrl, Color textColor, bool isDark) {
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
          // 🔹 Heading and Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
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
                padding: const EdgeInsets.only(right: 15.0),
                child: Obx(() {
                  final temps = [
                    _mqttController.sensorTemp1.value,
                    _mqttController.sensorTemp2.value,
                    _mqttController.sensorTemp3.value,
                    _mqttController.sensorTemp4.value,
                  ];
                  return Text(
                    '${'temp'.tr} ${double.parse(temps[index]).toStringAsFixed(1)}°C',
                    style:
                        TextStyle(fontSize: Get.width * 0.04, color: textColor),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🔹 Offset control row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  headings[index].tr,
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor().actual,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('offset'.tr, style: TextStyle(color: textColor)),
                  IconButton(
                    onPressed: () {
                      _mqttController.isUserInteracting.value = true;
                      ctrl.changeOffset(index, -1);
                      _resetPublishTimer();
                    },
                    icon: Icon(Icons.remove, color: textColor),
                  ),
                  Obx(() {
                    final offsets = [
                      int.tryParse(_mqttController.offsett1.value) ?? 0,
                      int.tryParse(_mqttController.offsett2.value) ?? 0,
                      int.tryParse(_mqttController.offsett3.value) ?? 0,
                      int.tryParse(_mqttController.offsett4.value) ?? 0,
                    ];
                    return Text(
                      '${offsets[index]}°C',
                      style: TextStyle(color: textColor),
                    );
                  }),
                  IconButton(
                    onPressed: () {
                      _mqttController.isUserInteracting.value = true;
                      ctrl.changeOffset(index, 1);
                      _resetPublishTimer();
                    },
                    icon: Icon(Icons.add, color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetPublishTimer() {
    publishTimer?.cancel();
    publishTimer = Timer(const Duration(seconds: 1), () {
      _mqttController.buildJsonPayloadSensor();
      publishTimer = Timer(const Duration(seconds: 1), () {
        _mqttController.isUserInteracting.value = false;
      });
    });
  }
}
