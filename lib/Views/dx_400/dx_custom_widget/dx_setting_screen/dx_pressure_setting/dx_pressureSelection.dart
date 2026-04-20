import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxPressureselection extends StatefulWidget {
  final String title;
  final RxBool pressureUnit;
  final RxString pressureType;
  final RxString pressureRange;
  const DxPressureselection(
      {super.key,
      required this.title,
      required this.pressureUnit,
      required this.pressureType,
      required this.pressureRange});

  @override
  State<DxPressureselection> createState() => _DxPressureselectionState();
}

class _DxPressureselectionState extends State<DxPressureselection> {
  final MqttController _mqttController = Get.find<MqttController>();
  final List<String> params = ['0-5V', '4-20mA'];
  final List<String> pressureparams = ['bar', 'PSI'];
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColor().actual,
        title: Text(
          '${widget.title} ${'sensorsConfig'.tr}',
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: Get.height * 0.01),
          for (int i = 0; i < 1; i++) ...[
            _buildSensorBox(i, params, pressureparams, textColor, isDark),
            SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  String getParameterName(String value) {
    switch (value) {
      case '1':
        return '0-5V';
      case '2':
        return '4-20mA';

      default:
        return 'none'.tr;
    }
  }

  String getParameterNamePressure(bool value) {
    switch (value) {
      case false:
        return 'bar';
      case true:
        return 'PSI';
    }
  }

  Widget _buildSensorBox(int index, List<String> params,
      List<String> pressureparams, Color textColor, bool isDark) {
    return Column(
      children: [
        Container(
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
                      'pressureUnit'.tr,
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      bool selectedValue = widget.pressureUnit.value;

                      int index = 0;
                      if (selectedValue == false) {
                        index = 0;
                      } else if (selectedValue == true) {
                        index = 1;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            _showSelectionPressureDialog(index, pressureparams,
                                textColor, isDark, selectedValue);
                          },
                          child: Text(
                            getParameterNamePressure(selectedValue),
                            style: TextStyle(
                              color: ThemeColor().actual,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
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
                      'sensorMaxRange'.tr,
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        showRangeDialog(context, _mqttController);
                      },
                      child: Obx(
                        () => Text(
                          widget.pressureRange.value,
                          style: TextStyle(
                            color: ThemeColor().actual,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
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
                      'sensorOutputType'.tr,
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      String selectedValue = widget.pressureType.value;

                      int index = 0;
                      if (selectedValue == '1') {
                        index = 0;
                      } else if (selectedValue == '2') {
                        index = 1;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            _showSelectionDialog(index, params, textColor,
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
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showRangeDialog(BuildContext context, MqttController mqttController) {
    final inputController = TextEditingController();
    final errorMessage = ''.obs;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Text(
              widget.pressureUnit.value
                  ? 'Enter Pressure (PSI)'
                  : 'Enter Pressure (bar)',
              style: TextStyle(
                color: ThemeColor().actual,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Value",
                  labelStyle: TextStyle(color: ThemeColor().actual),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ThemeColor().actual, width: 2),
                  ),
                ),
                cursorColor: ThemeColor().actual,
              ),
              SizedBox(height: 10),
              Obx(() => Text(
                    errorMessage.value,
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: ThemeColor().actual,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  final text = inputController.text;
                  final int? val = int.tryParse(text);

                  if (val == null) {
                    errorMessage.value = 'Please enter a valid number';
                    return;
                  }

                  final max = widget.pressureUnit.value ? 725 : 50;
                  final unitLabel = widget.pressureUnit.value ? 'PSI' : 'bar';

                  if (val < 0 || val > max) {
                    errorMessage.value =
                        'Value must be between 0 and $max $unitLabel';
                  } else {
                    // ✅ Set value in controller
                    widget.pressureRange.value =
                        val.toString(); // ✅ convert to String

                    errorMessage.value = '';
                    Get.back(); // Close dialog


                    // Build MQTT message or update UI
                    mqttController.buildJsonPayloadDXPressure();
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: ThemeColor().actual,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        );
      },
    );
  }

  void _showSelectionDialog(int index, List<String> params, Color textColor,
      bool isDark, String selectedValue) {
    Get.defaultDialog(
      title: 'Select Sensor Type',
      backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(params.length, (i) {
          final param = params[i];
          final paramValue = (i + 1).toString(); // '1' or '2'
          final isSelected = selectedValue == paramValue;

          return GestureDetector(
            onTap: () {
              if (isSelected) {
                widget.pressureType.value = '0'; // Set to 0 when deselected
                log('Deselected: $param ($paramValue)');
              } else {
                widget.pressureType.value = paramValue;
                log('Selected: $param ($paramValue)');
              }
              _mqttController.buildJsonPayloadDXPressure();
              Get.back();
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? Colors.green
                    : ThemeColor().actual.withOpacity(0.2),
              ),
              child: Text(
                param,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showSelectionPressureDialog(int index, List<String> params,
      Color textColor, bool isDark, bool selectedValue) {
    Timer? publishTimer;
    Get.defaultDialog(
      title: 'Select Unit',
      backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(params.length, (i) {
          final param = params[i];
          final paramValue = i == 1;
          final isSelected = selectedValue == paramValue;

          return GestureDetector(

            
            onTap: () {
              _mqttController.isUserInteracting.value = true;
              if (isSelected) {
                log('Already selected: $param ($paramValue)');
              } else {
                widget.pressureUnit.value = paramValue;
                log('Selected: $param ($paramValue)');
                publishTimer?.cancel();
                publishTimer = Timer(Duration(seconds: 1), () {
                  _mqttController.buildJsonPayloadDXPressure();
                });
              }
              publishTimer = Timer(Duration(seconds: 1), () {
                _mqttController.isUserInteracting.value = false;
              });
              Get.back();
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? Colors.green
                    : ThemeColor().actual.withOpacity(0.2),
              ),
              child: Text(
                param,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
