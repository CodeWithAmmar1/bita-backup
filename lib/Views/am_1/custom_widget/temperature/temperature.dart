import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperature_widget.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperatures_settings/discharge_setting.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperatures_settings/return_alert_setting.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperatures_settings/return_setpoint_setting.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperatures_settings/suction_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TemperatureAm1 extends StatelessWidget {
  TemperatureAm1({super.key});
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
            'temperatureSetting'.tr,
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
                        onTap: () => Get.to(() => ReturnAlertSettingAm1()),
                        child: Obx(() => TemperatureWidgetAm1(
                              limit: 40,
                              title: 'returnAlert'.tr,
                              setpoint:
                                  _mqttController.tempsphigh.value.toString(),
                              high: 'alertTemp'.trParams({
                                'value':
                                    _mqttController.tempsphigh.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.tempsphigh.value <=
                                          _mqttController.returnlinetemp.value
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
                          onTap: () => Get.to(() => ReturnSetPointSettingAm1()),
                          child: Obx(
                            () => TemperatureWidgetAm1(
                              limit: 35,
                              title: 'returnSp'.tr,
                              setpoint:
                                  _mqttController.tempsplow.value.toString(),
                              high: 'setPoint'.trParams({
                                'value':
                                    _mqttController.tempsplow.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.tempsplow.value <=
                                          _mqttController.returnlinetemp.value
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
                const SizedBox(height: 12),
                // Row 2
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => SuctionSettingAm1()),
                        child: Obx(() => TemperatureWidgetAm1(
                              limit: 100,
                              title: 'suction'.tr,
                              setpoint:
                                  _mqttController.tempsp2.value.toString(),
                              low: 'lowTemp'.trParams({
                                'value':
                                    _mqttController.tempsp2.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.suctionlinetemp.value <=
                                          _mqttController.tempsp2.value
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
                        onTap: () => Get.to(() => DischargeSettingAm1()),
                        child: Obx(() => TemperatureWidgetAm1(
                              limit: 200,
                              title: 'discharge'.tr,
                              setpoint:
                                  _mqttController.tempsp1.value.toString(),
                              high: 'highTemp'.trParams({
                                'value':
                                    _mqttController.tempsp1.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.dischargelinetemp.value >=
                                          _mqttController.tempsp1.value
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                            )),
                      ),
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
