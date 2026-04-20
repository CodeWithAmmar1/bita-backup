import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_setting_screen/dx_oilSelection.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_setting_screen/dx_pressure_setting/dx_pressure_setting_page.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_setting_screen/dx_temperatureSelection.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxSettingScreen extends StatefulWidget {
  const DxSettingScreen({super.key});

  @override
  State<DxSettingScreen> createState() => _DxSettingScreenState();
}

class _DxSettingScreenState extends State<DxSettingScreen> {
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
          'settings'.tr,
          style: TextStyle(
            color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        bool isDisabled = _mqttController.dxcomp1status.value == 1;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(()=>DxTemperatureselection());
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
                    'tempSensorsConfig'.tr,
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
                        Get.to(()=> DxPressureSettingPage());
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
                        Get.to(() => DxOilselection());
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
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        );
      }),
    );
  }
}
