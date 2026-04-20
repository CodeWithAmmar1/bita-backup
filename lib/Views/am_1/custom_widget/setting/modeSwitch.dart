import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/userSettingAm1.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Modeswitch extends StatefulWidget {
  const Modeswitch({super.key});

  @override
  State<Modeswitch> createState() => _ModeswitchState();
}
 final MqttController _mqttController = Get.find<MqttController>();
class _ModeswitchState extends State<Modeswitch> {
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
       backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'operation_mode_setting'.tr,
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
        automaticallyImplyLeading: true,
      ),
      body: 
      Column(
        children: [
          SizedBox(height: 20),
          Obx(
              () => RestartToggle(
                LeftText: " ${"monitoring".tr}\n     ${"mode".tr}",
                rightText: " ${"controlling".tr} \n      ${"mode".tr}",
                title: 'operation_mode_selection'.tr,
                value: _mqttController.isModeSwitchAm1.value,
                onTap: () async {
                  _mqttController.modeSwLoadingAm1.value = true;
                  final newValue = !_mqttController.isModeSwitchAm1.value;
                  await _mqttController.modeSwitchAm1(newValue);
                  _mqttController.modeSwLoadingAm1.value = false;
                  return newValue;
                },
              ),
          ),
        ],
      ),
    ); 
    
         
  }
}