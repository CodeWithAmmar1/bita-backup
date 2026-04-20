import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/RCMaster/widget/rcm_setpoint_Screens/suc_pressure_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/Temp_Box_RCM/temperature_widget_RC.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class PressureRcm extends StatelessWidget {
  PressureRcm({super.key});
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          title: Text(
            'Pressure Settings'.tr,
            style: TextStyle(
              fontSize: shortestSide * 0.06,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                      onTap: () => Get.to(() => SucPressureRcm()),
                      child: Obx(
                        () => TemperatureWidgetRc( unit: "PSI",
                          limit: 100,
                          title: 'Suction'.tr,
                          setpoint: _mqttController.rcSucpreSp.value.toString(),
                          high:
                              "${"Suction:"} ${_mqttController.rcSucpreSp.value.toString()}",
                          getColorLogic: (pressure) =>
                              _mqttController.rcSucpreSp.value <=
                                      _mqttController.rcSucpre.value
                                  ? Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black
                                  : Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
