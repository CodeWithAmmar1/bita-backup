import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TempSelectionam1 extends StatefulWidget {
  const TempSelectionam1({super.key});

  @override
  State<TempSelectionam1> createState() => _TempSelectionam1State();
}

Timer? publishTimer;

class _TempSelectionam1State extends State<TempSelectionam1> {
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  final List<String> fixedHeadings = [
    'suction'.tr,
    'discharge'.tr,
    'supply'.tr,
    'return'.tr,
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
              SizedBox(height: 20),
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
          // Sensor Title + Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  fixedHeadings[index],
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor().actual,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Obx(() {
                  final temps = [
                    _mqttController.sensorAm1Temp1.value,
                    _mqttController.sensorAm1Temp2.value,
                    _mqttController.sensorAm1Temp3.value,
                    _mqttController.sensorAm1Temp4.value,
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

          // Offset Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Row(
                children: [
                  Text('offset'.tr, style: TextStyle(color: textColor)),
                  IconButton(
                    onPressed: () {
                      _mqttController.isUserInteracting.value = true;
                      ctrl.changeOffsetAm1(index, -0.1);
                      _resetPublishTimer();
                    },
                    icon: Icon(Icons.remove, color: textColor),
                  ),
                  Obx(() {
                    final offsets = [
                      double.tryParse(_mqttController.offsett1Am1.value) ?? 0.0,
                      double.tryParse(_mqttController.offsett2Am1.value) ?? 0.0,
                      double.tryParse(_mqttController.offsett3Am1.value) ?? 0.0,
                      double.tryParse(_mqttController.offsett4Am1.value) ?? 0.0,
                    ];
                    return Text(
                      '${offsets[index].toStringAsFixed(1)}°C',
                      style: TextStyle(color: textColor),
                    );
                  }),
                  IconButton(
                    onPressed: () {
                      _mqttController.isUserInteracting.value = true;
                      ctrl.changeOffsetAm1(index, 0.1);
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
      _mqttController.buildJsonPayloadAm1ASensor();
      publishTimer = Timer(const Duration(seconds: 1), () {
        _mqttController.isUserInteracting.value = false;
      });
    });
  }
}
