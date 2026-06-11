import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SensorselectiondmA extends StatefulWidget {
  final bool permission;
  final String sub;
  final String sup;
  final String ret;
  const SensorselectiondmA(
      {super.key,
      required this.permission,
      required this.sub,
      required this.sup,
      required this.ret});

  @override
  State<SensorselectiondmA> createState() => _SensorselectiondmAState();
}

Timer? publishTimer;

class _SensorselectiondmAState extends State<SensorselectiondmA> {
  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  List<String> get params => [
        'none'.tr,
        'suction'.tr,
        'discharge'.tr,
        widget.sub.tr,
        'Spray'.tr,
        widget.sup.tr,
        widget.ret.tr,
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
            for (int i = 0; i < 6; i++) ...[
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
        return widget.sub.tr;
      case '4':
        return 'Spray'.tr;
      case '5':
        return widget.sup.tr;
      case '6':
        return widget.ret.tr;
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
                    _mqttController.sensorTemp1A.value,
                    _mqttController.sensorTemp2A.value,
                    _mqttController.sensorTemp3A.value,
                    _mqttController.sensorTemp4A.value,
                    _mqttController.sensorTemp5.value,
                    _mqttController.sensorTemp6.value,
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
                  selectedValue = _mqttController.selection1A.value;
                } else if (index == 1) {
                  selectedValue = _mqttController.selection2A.value;
                } else if (index == 2) {
                  selectedValue = _mqttController.selection3A.value;
                } else if (index == 3) {
                  selectedValue = _mqttController.selection4A.value;
                } else if (index == 4) {
                  selectedValue = _mqttController.selection5.value;
                } else if (index == 5) {
                  selectedValue = _mqttController.selection6.value;
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
                        ctrl.dXMasterchangeOffsetA(index, -1);
                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.buildJsonPayloadDMA();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.isUserInteracting.value = false;
                          });
                        });
                      },
                      icon: Icon(Icons.remove, color: textColor)),
                  Obx(() {
                    final offsets = [
                      int.tryParse(_mqttController.offsett1A.value) ?? 0,
                      int.tryParse(_mqttController.offsett2A.value) ?? 0,
                      int.tryParse(_mqttController.offsett3A.value) ?? 0,
                      int.tryParse(_mqttController.offsett4A.value) ?? 0,
                      int.tryParse(_mqttController.offsett5.value) ?? 0,
                      int.tryParse(_mqttController.offsett6.value) ?? 0,
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
                        ctrl.dXMasterchangeOffsetA(index, 1);
                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.buildJsonPayloadDMA();
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
          _mqttController.selection1A.value,
          _mqttController.selection2A.value,
          _mqttController.selection3A.value,
          _mqttController.selection4A.value,
          _mqttController.selection5.value,
          _mqttController.selection6.value,
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
                _mqttController.selection1A.value = value;
              } else if (sensor == 1) {
                _mqttController.selection2A.value = value;
              } else if (sensor == 2) {
                _mqttController.selection3A.value = value;
              } else if (sensor == 3) {
                _mqttController.selection4A.value = value;
              } else if (sensor == 4) {
                _mqttController.selection5.value = value;
              } else if (sensor == 5) {
                _mqttController.selection6.value = value;
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
                        _mqttController.buildJsonPayloadDMA();
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
