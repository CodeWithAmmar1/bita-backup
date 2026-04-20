import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am2-444/sensorselectionAm2.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/oilSelection.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/pressure_setting/operationMode.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/pressure_setting/pressure_setting_page.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/temperatureSelection.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SettingPage extends StatefulWidget {
  final bool isFromDevicePage;
  const SettingPage({super.key, required this.isFromDevicePage});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'System Settings'.tr,
          style: TextStyle(
            fontSize: Get.width * 0.06,
            color: Get.isDarkMode ? ThemeColor().mode1Sec : ThemeColor().mode2,
          ),
        ),
      ),
      body: Obx(() {
        bool isDisabled = _mqttController.comp1status.value == 1;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(() => Operationmode());
                      },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDisabled ? Colors.grey : textColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDisabled ? Colors.grey : textColor,
                    size: 20,
                  ),
                  title: Text(
                    'operation_mode_selection'.tr,
                    style:
                        TextStyle(color: isDisabled ? Colors.grey : textColor),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        if (widget.isFromDevicePage) {
                          Get.to(() => Sensorselectionam2());
                        } else {
                          Get.to(() => Temperatureselection());
                        }
                      },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDisabled ? Colors.grey : textColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDisabled ? Colors.grey : textColor,
                    size: 20,
                  ),
                  title: Text(
                    'tempSensorsSetting'.tr,
                    style:
                        TextStyle(color: isDisabled ? Colors.grey : textColor),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(PressureSettingPage());
                      },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDisabled ? Colors.grey : textColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDisabled ? Colors.grey : textColor,
                    size: 20,
                  ),
                  title: Text(
                    'pressureSensorsConfig'.tr,
                    style:
                        TextStyle(color: isDisabled ? Colors.grey : textColor),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(() => Oilselection());
                      },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDisabled ? Colors.grey : textColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDisabled ? Colors.grey : textColor,
                    size: 20,
                  ),
                  title: Text(
                    'enableDisableConfig'.tr,
                    style:
                        TextStyle(color: isDisabled ? Colors.grey : textColor),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
