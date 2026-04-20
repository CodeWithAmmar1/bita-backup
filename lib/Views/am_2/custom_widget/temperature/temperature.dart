import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperature_widget.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/discharge_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/return_alert_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/suction_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperatures_settings/return_setpoint_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Temperature extends StatelessWidget {
  Temperature({super.key});
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
                        onTap: () => Get.to(() => ReturnAlertSetting()),
                        child: Obx(() => TemperatureWidget(
                              limit: _mqttController.ftoC.value ? 100 : 212,
                              title: 'returnAlert'.tr,
                              setpoint:
                                  _mqttController.temp1setlow.value.toString(),
                              high: 'alertTemp'.trParams({
                                'value':
                                    _mqttController.temp1setlow.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.temp1setlow.value <=
                                          _mqttController.temp1.value
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(width: 12),
                    Obx(() {
                      if (_mqttController.isModeSwitch.value) {
                        return Expanded(
                          child: GestureDetector(
                              onTap: () =>
                                  Get.to(() => ReturnSetPointSetting()),
                              child: TemperatureWidget(
                                limit: _mqttController.ftoC.value ? 100 : 212,
                                title: 'returnSp'.tr,
                                setpoint: _mqttController.temp1sethigh.value
                                    .toString(),
                                high: 'setPoint'.trParams({
                                  'value': _mqttController.temp1sethigh.value
                                      .toString()
                                }),
                                getColorLogic: (pressure) =>
                                    _mqttController.temp1sethigh.value <=
                                            _mqttController.temp1.value
                                        ? Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black
                                        : Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                              )),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ],
                ),

                const SizedBox(height: 12),

                // Row 2
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => SuctionSetting()),
                        child: Obx(() => TemperatureWidget(
                              limit: _mqttController.ftoC.value ? 100 : 212,
                              title: 'suction'.tr,
                              setpoint:
                                  _mqttController.temp3sethigh.value.toString(),
                              low: 'lowTemp'.trParams({
                                'value': _mqttController.temp3sethigh.value
                                    .toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.temp3.value <=
                                          _mqttController.temp3sethigh.value
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
                        onTap: () => Get.to(() => DischargeSetting()),
                        child: Obx(() => TemperatureWidget(
                              limit: _mqttController.ftoC.value ? 200 : 392,
                              title: 'discharge'.tr,
                              setpoint:
                                  _mqttController.temp4setlow.value.toString(),
                              high: 'highTemp'.trParams({
                                'value':
                                    _mqttController.temp4setlow.value.toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.temp4.value >=
                                          _mqttController.temp4setlow.value
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
