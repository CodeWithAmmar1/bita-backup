import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/RCMaster/widget/rcm_setpoint_Screens/suction_setpoint_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/rcm_setpoint_Screens/superheat_setpoint_rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/Temp_Box_RCM/temperature_widget_RC.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TemperatureRcm extends StatelessWidget {
  TemperatureRcm({super.key});
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
            'Temperature Settings'.tr,
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
              children: [
                // Row 1
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => SuctionSetpointRcm()),
                        child: Obx(() => TemperatureWidgetRc(
                              unit: '°F',
                              limit: 100,
                              title: 'Suction'.tr,
                              setpoint:
                                  _mqttController.rcSucTempSp.value.toString(),
                              high: 'SuctionTemp'.trParams({
                                'value':
                                    _mqttController.rcSucTempSp.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.rcSucTempSp.value <=
                                          _mqttController.rcSucTemp.value
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => Get.to(() => SuperheatSetpointRcm()),
                          child: Obx(
                            () => TemperatureWidgetRc(
                              unit: '°F',
                              limit: 100,
                              title: 'SuperHeat (SP)'.tr,
                              setpoint:
                                  _mqttController.rcSuperSp.value.toString(),
                              high: 'SuperHeat'.trParams({
                                'value':
                                    _mqttController.rcSuperSp.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  // _mqttController.rcSuperSp.value <=
                                  //         _mqttController.rcSuper.value
                                  //     ? Get.isDarkMode
                                  //         ? Colors.white
                                  //         : Colors.black
                                      // :
                                       Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
