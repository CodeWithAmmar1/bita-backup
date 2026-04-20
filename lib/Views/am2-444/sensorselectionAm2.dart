import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Sensorselectionam2 extends StatefulWidget {
  const Sensorselectionam2({super.key});

  @override
  State<Sensorselectionam2> createState() => _Sensorselectionam2State();
}

Timer? publishTimer;

class _Sensorselectionam2State extends State<Sensorselectionam2> {
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());
  final List<String> params = [
    'none'.tr,
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
          'tempSensorsConfig'.tr,
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.01),
            for (int i = 0; i < 4; i++) ...[
              _buildSensorBox(i, controller, params, textColor, isDark),
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  String getParameterName(String value) {
    switch (value) {
      case '0':
        return 'none'.tr;
      case '1':
        return 'suction'.tr;
      case '2':
        return 'discharge'.tr;
      case '3':
        return 'supply'.tr;
      case '4':
        return 'return'.tr;
      default:
        return 'none'.tr;
    }
  }

  Widget _buildSensorBox(int index, SensorSwitchController ctrl,
      List<String> params, Color textColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                padding: const EdgeInsets.only(left: 10.0),
                child: Obx(() {
                  final temps = [
                    _mqttController.sensorTemp1.value,
                    _mqttController.sensorTemp2.value,
                    _mqttController.sensorTemp3.value,
                    _mqttController.sensorTemp4.value,
                  ];

                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      '${'temp'.tr} ${double.parse(temps[index]).toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: Get.width * 0.04,
                        color: textColor,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                String selectedValue = '';
                if (index == 0) {
                  selectedValue = _mqttController.selection1Am2.value;
                } else if (index == 1) {
                  selectedValue = _mqttController.selection2Am2.value;
                } else if (index == 2) {
                  selectedValue = _mqttController.selection3Am2.value;
                } else if (index == 3) {
                  selectedValue = _mqttController.selection4Am2.value;
                }

                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      _showSelectionDialog(index, ctrl, params, textColor,
                          isDark, selectedValue);
                    },
                    child: Text(
                      getParameterName(selectedValue),
                      style: TextStyle(
                        color: ThemeColor().actual,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('offset'.tr, style: TextStyle(color: textColor)),
                  IconButton(
                      onPressed: () {
                        _mqttController.isUserInteracting.value = true;
                        ctrl.changeOffset(index, -0.1);
                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.buildJsonPayloadAm2444Sensor();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.isUserInteracting.value = false;
                          });
                        });
                      },
                      icon: Icon(Icons.remove, color: textColor)),
                  Obx(() {
                    final offsets = [
                      double.tryParse(_mqttController.offsett1.value) ?? 0.0,
                      double.tryParse(_mqttController.offsett2.value) ?? 0.0,
                      double.tryParse(_mqttController.offsett3.value) ?? 0.0,
                      double.tryParse(_mqttController.offsett4.value) ?? 0.0,
                    ];

                    return Text(
                      '${offsets[index].toString()}°C',
                      style: TextStyle(
                        color: textColor,
                      ),
                    );
                  }),
                  IconButton(
                      onPressed: () {
                        _mqttController.isUserInteracting.value = true;
                        ctrl.changeOffset(index, 0.1);
                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.buildJsonPayloadAm2444Sensor();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.isUserInteracting.value = false;
                          });
                        });
                      },
                      icon: Icon(Icons.add, color: textColor)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog(int sensorIndex, SensorSwitchController ctrl,
      List<String> params, Color textColor, bool isDark, String selectedValue) {
    Get.defaultDialog(
      title: 'Select One',
      backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
      content: Obx(() {
        // current selections of all sensors (strings '0','1','2','3','4')
        final List<String> currentSelections = [
          _mqttController.selection1Am2.value,
          _mqttController.selection2Am2.value,
          _mqttController.selection3Am2.value,
          _mqttController.selection4Am2.value,
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(params.length, (optionIndex) {
            final optionLabel = params[optionIndex];
            final optionValue = optionIndex.toString(); // '0','1',...

            // if optionValue != '0' (None) and it's already used by another sensor -> mark used
            final alreadyUsed = optionValue != '0' &&
                currentSelections.contains(optionValue) &&
                currentSelections[sensorIndex] != optionValue;

            final isSelected = selectedValue == optionValue;

            void setSelectionForSensor(int sensor, String value) {
              if (sensor == 0) {
                _mqttController.selection1Am2.value = value;
              } else if (sensor == 1) {
                _mqttController.selection2Am2.value = value;
              } else if (sensor == 2) {
                _mqttController.selection3Am2.value = value;
              } else if (sensor == 3) {
                _mqttController.selection4Am2.value = value;
              }
            }

            return GestureDetector(
              onTap: alreadyUsed
                  ? null
                  : () {
                      // set selection (can be '0' to clear / None)
                      _mqttController.isUserInteracting.value = true;
                      setSelectionForSensor(sensorIndex, optionValue);
                      log('Selected: $optionLabel ($optionValue) for sensor $sensorIndex');
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 1), () {
                        _mqttController.buildJsonPayloadAm2444Sensor();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.isUserInteracting.value = false;
                        });
                      });
                      Get.back();
                    },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? Colors.green
                      : ThemeColor().actual.withOpacity(0.2),
                ),
                child: Text(
                  optionLabel,
                  style: TextStyle(
                    color: alreadyUsed ? Colors.grey : textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
