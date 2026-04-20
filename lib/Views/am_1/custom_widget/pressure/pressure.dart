import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/pressure/pressure_widget.dart';
import 'package:testappbita/Views/am_1/custom_widget/pressure/pressures_setting/discharge_pressure_setting.dart';
import 'package:testappbita/Views/am_1/custom_widget/pressure/pressures_setting/suction_pressure_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class PressuresAm1 extends StatelessWidget {
  PressuresAm1({super.key});

  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final shortestSide = media.size.shortestSide;
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          title: Text(
            'pressuresSetting'.tr,
            style: TextStyle(
              fontSize: shortestSide * 0.06,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => SuctionPressureSettingAm1()),
                        child: Obx(() => PressurewidgetAm1(
                              limit: 300,
                              title: "${'suction'.tr} (PSI)",
                              low: _mqttController.pressuresp1.value
                                  .toStringAsFixed(0),
                              setpoint:
                                  _mqttController.pressuresp1.value.toString(),
                              getColorLogic: (_) =>
                                  _mqttController.suctionpressure.value <=
                                          _mqttController.pressuresp1.value
                                      ? Colors.red
                                      : textColor,
                            )),
                      ),
                    ),
                    SizedBox(width: shortestSide * 0.03),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            Get.to(() => DischargePressureSettingAm1()),
                        child: Obx(() => PressurewidgetAm1(
                              limit: 725,
                              title: "${'discharge'.tr} (PSI)",
                              high:
                                  _mqttController.pressuresp2.value.toString(),
                              setpoint:
                                  _mqttController.pressuresp2.value.toString(),
                              getColorLogic: (_) =>
                                  _mqttController.dischargepressure.value >=
                                          _mqttController.pressuresp2.value
                                      ? Colors.red
                                      : textColor,
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
