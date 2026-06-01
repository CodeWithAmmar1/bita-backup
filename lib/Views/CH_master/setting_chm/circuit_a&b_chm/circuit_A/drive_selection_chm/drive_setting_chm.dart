import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/CH_master/setting_chm/circuit_a&b_chm/circuit_A/circuit_setting_chm/circuit_selection_setting_chm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DriveSettingChm extends StatelessWidget {
  DriveSettingChm({super.key});
  final MqttController _mqttController = Get.find<MqttController>();
  final List<String> modes = ['S/D', 'DD', 'PW', 'VFD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'Drive Settings',
          style: TextStyle(
              fontSize: Get.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Drive Selection',
                    style: TextStyle(
                      fontSize: Get.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  // const SizedBox(width: 15),
                  Obx(
                    () => Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.25,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ThemeColor().actual,
                          width: 2,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _mqttController.selectedModeA.value,
                          isExpanded: true,

                          /// 🔥 Selected text style
                          selectedItemBuilder: (context) {
                            return modes.map((item) {
                              return Center(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColor()
                                        .actual, // selected text color
                                  ),
                                ),
                              );
                            }).toList();
                          },

                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            size: 30,
                          ),

                          dropdownColor: Get.isDarkMode
                              ? ThemeColor().mode2Sec
                              : ThemeColor().mode1Sec,

                          items: List.generate(
                            modes.length,
                            (index) => DropdownMenuItem<int>(
                              value: index,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: index ==
                                              _mqttController.selectedModeA.value
                                          ? ThemeColor().actual
                                          : Colors.transparent,
                                    ),
                                    Text(
                                      modes[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: index ==
                                                _mqttController
                                                    .selectedModeA.value
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: index ==
                                                _mqttController
                                                    .selectedModeA.value
                                            ? ThemeColor()
                                                .actual // 🔥 selected item color
                                            : (Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          onChanged: (index) {
                            if (index != null) {
                              log('switched to: $index');
                              _mqttController.selectedModeA.value = index;
                              _mqttController.buildJsonPayloadCiruitA();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (_mqttController.selectedModeA.value == 3) {
                return Column(
                  children: [
                    Text(
                      'Drive Selection',
                      style: TextStyle(
                          fontSize: Get.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                    SizedBox(height: 10),
                    DxNumberAdjChm(
                      unit: "Hz",
                      title: "VFD frequency Min",
                      value: _mqttController.vfdMinFrequencyA,
                      min: 0,
                      max: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DxNumberAdjChm(
                      unit: "Hz",
                      title: "VFD frequency Max",
                      value: _mqttController.vfdMaxFrequencyA,
                      min: 0,
                      max: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DxNumberAdjChm(
                      unit: "Sec",
                      title: "VFD Delay",
                      value: _mqttController.vfdDelayA,
                      min: 0,
                      max: 600,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}
