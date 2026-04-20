import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_mini/dx_custom_widget/dxMini_temperature/dxMini_temperature_widget.dart';
import 'package:testappbita/Views/dx_mini/dx_custom_widget/dxMini_temperature/dxMini_temperatures_settings/dxMini_discharge_setting.dart';
import 'package:testappbita/Views/dx_mini/dx_custom_widget/dxMini_temperature/dxMini_temperatures_settings/dxMini_return_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxMiniTemperature extends StatelessWidget {
  DxMiniTemperature({super.key});
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
        body: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only( left: 16, right: 16,),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => DxMiniReturnSetting()),
                    child: Obx(() => DxMiniTemperatureWidget(
                          limit: 100,
                          title: 'return'.tr,
                          setpoint: _mqttController.returnspDXM.value
                              .toString(),
                          low: 'lowTemp'.trParams({
                            'value': _mqttController.returnspDXM.value
                                .toString()
                          }),
                          getColorLogic: (pressure) =>
                              _mqttController.returnspDXM.value <=
                                      _mqttController.returnDXM.value
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
                    onTap: () => Get.to(() => DxMiniDischargeSetting()),
                    child: Obx(() => DxMiniTemperatureWidget(
                          limit: 200,
                          title: 'discharge'.tr,
                          setpoint: _mqttController.dischargespDXM.value
                              .toString(),
                          high: 'highTemp'.trParams({
                            'value': _mqttController.dischargespDXM.value
                                .toString()
                          }),
                          getColorLogic: (pressure) =>
                              _mqttController.dischargeDXM.value >=
                                      _mqttController.dischargespDXM.value
                                  ? Colors.red
                                  : Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
