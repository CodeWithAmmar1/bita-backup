import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_mini/dx_custom_widget/dxMini_setting_screen/dxMini_temperatureSelection.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxMiniSettingScreen extends StatefulWidget {
  const DxMiniSettingScreen({super.key});

  @override
  State<DxMiniSettingScreen> createState() => _DxSettingScreenState();
}

class _DxSettingScreenState extends State<DxMiniSettingScreen> {
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
        bool isDisabled = _mqttController.statusDXM.value == 1;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(()=>DxminiTemperatureselection());
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
            ],
          ),
        );
      }),
    );
  }
}
