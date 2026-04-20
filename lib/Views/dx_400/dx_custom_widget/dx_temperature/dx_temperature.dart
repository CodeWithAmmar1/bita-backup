import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperature_widget.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperatures_settings/dx_discharge_setting.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperatures_settings/dx_return_alert_setting.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperatures_settings/dx_return_setpoint_setting.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperatures_settings/dx_suction_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxTemperature extends StatelessWidget {
  DxTemperature({super.key});
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
                        onTap: () => Get.to(() => DxReturnAlertSetting()),
                        child: Obx(() => DxTemperatureWidget(
                              limit: 100,
                              title: 'returnAlert'.tr,
                              setpoint: _mqttController.dxtemp1setlow.value
                                  .toString(),
                              high: 'alertTemp'.trParams({
                                'value': _mqttController.dxtemp1setlow.value
                                    .toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.dxtemp1setlow.value <=
                                          _mqttController.dxtemp1.value
                                      ? Colors.red
                                      : Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(width: 12),
                    Obx(() {
                      if (_mqttController.dxisModeSwitch.value) {
                        return Expanded(
                          child: GestureDetector(
                              onTap: () =>
                                  Get.to(() => DxReturnSetpointSetting()),
                              child: DxTemperatureWidget(
                                limit: 100,
                                title: 'returnSp'.tr,
                                setpoint: _mqttController.dxtemp1sethigh.value
                                    .toString(),
                                high: 'setPoint'.trParams({
                                  'value': _mqttController.dxtemp1sethigh.value
                                      .toString()
                                }),
                                getColorLogic: (pressure) =>
                                    _mqttController.dxtemp1sethigh.value <=
                                            _mqttController.dxtemp1.value
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
                        onTap: () => Get.to(() => DxSuctionSetting()),
                        child: Obx(() => DxTemperatureWidget(
                              limit: 100,
                              title: 'suction'.tr,
                              setpoint: _mqttController.dxtemp3sethigh.value
                                  .toString(),
                              low: 'lowTemp'.trParams({
                                'value': _mqttController.dxtemp3sethigh.value
                                    .toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.dxtemp3.value <=
                                          _mqttController.dxtemp3sethigh.value
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
                        onTap: () => Get.to(() => DxDischargeSetting()),
                        child: Obx(() => DxTemperatureWidget(
                              limit: 200,
                              title: 'discharge'.tr,
                              setpoint: _mqttController.dxtemp4setlow.value
                                  .toString(),
                              high: 'highTemp'.trParams({
                                'value': _mqttController.dxtemp4setlow.value
                                    .toString()
                              }),
                              getColorLogic: (pressure) =>
                                  _mqttController.dxtemp4.value >=
                                          _mqttController.dxtemp4setlow.value
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
