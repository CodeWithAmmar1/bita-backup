import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/Steps_Exv/exv_steps_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/Min_&_Max_Exv/min_max_exv_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/ExvRcm_Setpoint_Setting/setpoint_widget_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/ExvRcm_Setpoint_Setting/sp_exv_widget_rcm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class ExvSettingRcm extends StatelessWidget {
  final RxInt min;
  final RxInt max;
  final RxDouble integral;
  final RxDouble derivative;
  final RxDouble proportional;
  final RxInt superHeat;

  final RxInt exvcurrentStep;
  final RxInt exvstepDelay;
  final RxInt exvmaxstep;
  ExvSettingRcm({
    super.key,
    required this.superHeat,
    required this.integral,
    required this.derivative,
    required this.proportional,
    required this.min,
    required this.max,
    required this.exvcurrentStep,
    required this.exvstepDelay,
    required this.exvmaxstep,
  });
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'EXV Settings',
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
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.to(() => SetpointWidgetRcm(
                      title: "Super Heat",
                      unit: "°C",
                      minValue: 2,
                      maxValue: 20,
                      value: superHeat,
                      onPublish: () {
                        _mqttController.buildJsonPayloadRcm();
                      },
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
                  'Super Heat'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SpExvWidgetRcm(
                      title: "Proportional",
                      unit: "°C",
                      minValue: 0.0,
                      maxValue: 20.0,
                      value: proportional,
                      onPublish: () {
                        _mqttController.buildJsonPayloadRcm();
                      },
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
                  'Proportional'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SpExvWidgetRcm(
                      title: "Integral",
                      unit: "°C",
                      minValue: 0.0,
                      maxValue: 20.0,
                      value: integral,
                      onPublish: () {
                        _mqttController.buildJsonPayloadRcm();
                      },
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
                  'Integral'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SpExvWidgetRcm(
                      title: "Deravtive",
                      unit: "°C",
                      minValue: 0.0,
                      maxValue: 20.0,
                      value: derivative,
                      onPublish: () {
                        _mqttController.buildJsonPayloadRcm();
                      },
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
                  'Deravtive'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => MinMaxExvRcm(
                      maxx: max,
                      minn: min,
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
                  'Min & Max EXV'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ExvStepsRcm(
                      exvcurrentStep: exvcurrentStep,
                      exvstepDelay: exvstepDelay,
                      exvmaxstep: exvmaxstep,
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
                  'EXV Steps'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
