import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_pressure/dx_pressure_widget.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_pressure/dx_pressures_setting/dx_discharge_pressure_setting.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_pressure/dx_pressures_setting/dx_oil_pressure_setting.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_pressure/dx_pressures_setting/dx_suction_pressure_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxPressure extends StatelessWidget {
  DxPressure({super.key});

  final MqttController _mqttController = Get.find<MqttController>();
  final SensorSwitchController controller = Get.put(SensorSwitchController());

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
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
              color: Get.isDarkMode ? Colors.white : Colors.black,
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

                // First Row: Suction & Discharge
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => DxSuctionPressureSetting()),
                        child: Obx(() => DxPressureWidget(
                              limit: 300,
                              title: "${'suction'.tr} (PSI)",
                              low: _mqttController.dxpsig1sethigh.value
                                  .toStringAsFixed(0),
                              setpoint:
                                  _mqttController.dxpsig1sethigh.value.toString(),
                              getColorLogic: (_) =>
                                  _mqttController.dxpsig1.value <=
                                          _mqttController.dxpsig1sethigh.value
                                      ? Colors.red
                                      : textColor,
                            )),
                      ),
                    ),
                    SizedBox(width: shortestSide * 0.03),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => DxDischargePressureSetting()),
                        child: Obx(() => DxPressureWidget(
                              limit: 725,
                              title: "${'discharge'.tr} (PSI)",
                              high:
                                  _mqttController.dxpsig2setlow.value.toString(),
                              setpoint:
                                  _mqttController.dxpsig2setlow.value.toString(),
                              getColorLogic: (_) =>
                                  _mqttController.dxpsig2.value >=
                                          _mqttController.dxpsig2setlow.value
                                      ? Colors.red
                                      : textColor,
                            )),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: baseSize * 0.02),

                // Oil Pressure if Visible
                Obx(() {
                  if (_mqttController.dxisOilPressureVisible.value ||
                      _mqttController.dxisSwitchBoxVisible.value) {
                    return Column(
                      children: [
                        if (_mqttController.dxisOilPressureVisible.value)
                          GestureDetector(
                            onTap: () => Get.to(() => DxOilPressureSetting()),
                            child: Obx(() => DxPressureWidget(
                                  limit: 725,
                                  title: "${"oil".tr} (PSI)",
                                  low: _mqttController.dxpsig3sethigh.value
                                      .toString(),
                                  setpoint: _mqttController.dxpsig3sethigh.value
                                      .toString(),
                                  getColorLogic: (_) =>
                                      _mqttController.dxpsig3.value <=
                                              _mqttController.dxpsig3sethigh.value
                                          ? Colors.red
                                          : textColor,
                                )),
                          ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
