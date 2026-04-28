import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/telecome/telecom_widgets/tempearture/telecome_temp_widget.dart';
import 'package:testappbita/Views/telecome/telecom_widgets/tempearture/temperatures_setting/humidity_sp.dart';
import 'package:testappbita/Views/telecome/telecom_widgets/tempearture/temperatures_setting/temperature_alert_telecome.dart';
import 'package:testappbita/Views/telecome/telecom_widgets/tempearture/temperatures_setting/temperature_setpoint_telecome.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TelecomTemperature extends StatelessWidget {
  TelecomTemperature({super.key});
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          title: Text(
            'parameters_set_points'.tr,
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
                        onTap: () => Get.to(() => TemperatureAlertTelecome()),
                        child: Obx(() => TelecomeTempWidget(
                              unit: "°C",
                              limit: 40,
                              title: 'temp_alert'.tr,
                              setpoint:
                                  _mqttController.tempAlertTel.value.toString(),
                              high:
                                  _mqttController.tempAlertTel.value.toString(),
                              getColorLogic: (pressure) =>
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(width: 12),
                    Obx(() {
                      return Expanded(
                        child: GestureDetector(
                            onTap: () =>
                                Get.to(() => TemperatureSetpointTelecome()),
                            child: TelecomeTempWidget(
                                unit: "°C",
                                limit: 30,
                                title: 'temp_set_point'.tr,
                                setpoint: _mqttController.tempSetPointTel.value
                                    .toString(),
                                high: _mqttController.tempSetPointTel.value
                                    .toString(),
                                getColorLogic: (pressure) => Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black)),
                      );
                    }),
                  ],
                ),
                SizedBox(height: baseSize * 0.03),
                Obx(
                  () => GestureDetector(
                      onTap: () => Get.to(() => HumiditySp()),
                      child: TelecomeTempWidget(
                          unit: "%",
                          limit: 100,
                          title: 'humidity_rh'.tr,
                          setpoint: _mqttController.humiditySetPointTel.value
                              .toString(),
                          high: _mqttController.humiditySetPointTel.value
                              .toString(),
                          getColorLogic: (pressure) =>
                              Get.isDarkMode ? Colors.white : Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
