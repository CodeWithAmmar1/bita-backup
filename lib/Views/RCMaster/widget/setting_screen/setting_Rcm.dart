import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/exv_setting_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/pressureselection/pressureselection.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SettingRcm extends StatefulWidget {
  const SettingRcm({super.key});
  @override
  State<SettingRcm> createState() => _SettingRcmState();
}

class _SettingRcmState extends State<SettingRcm> {
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'Settings',
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
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => ExvSettingRcm(
                        superHeat: _mqttController.rcSuperSp,
                        proportional: _mqttController.rcpropostionalsp,
                        integral: _mqttController.rcintegralsp,
                        derivative: _mqttController.rcderivativesp,
                        min: _mqttController.rcminValue,
                        max: _mqttController.rcmaxValue,
                        exvcurrentStep: _mqttController.rcexvCurrentStep,
                        exvmaxstep: _mqttController.rcexvMaxStep,
                        exvstepDelay: _mqttController.rcexvStepDelay,
                      ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'EXV Settings'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(PressureselectionRC(
                    title: 'oil'.tr,
                    pressureUnit: _mqttController.rcpressureUnit,
                    pressureType: _mqttController.rcpressureType,
                    pressureRange: _mqttController.rcpressureRange,
                  ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'oilPressureSensor'.tr,
                    style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
