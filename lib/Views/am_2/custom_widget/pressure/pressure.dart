import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressure_widget.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressures_setting/discharge_pressure_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressures_setting/oil_pressure_setting.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressures_setting/suction_pressure_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Pressures extends StatelessWidget {
  Pressures({super.key});

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
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: (!_mqttController
                                .isSuctionPressureVisible.value ||
                            !_mqttController.isDischargePressureVisible.value)
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_mqttController.isSuctionPressureVisible.value)
                        _mqttController.isDischargePressureVisible.value
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.to(() => SuctionPressureSetting()),
                                  child: Pressurewidget(
                                    limit: _mqttController.psiTobar.value
                                        ? 300
                                        : 21,
                                    title:
                                        "${'suction'.tr} ${(_mqttController.psiTobar.value ? "(PSI)" : "(Bar)")} ",
                                    low: _mqttController.psig1sethigh.value
                                        .toStringAsFixed(0),
                                    setpoint: _mqttController.psig1sethigh.value
                                        .toString(),
                                    getColorLogic: (_) => _mqttController
                                                .psig1.value <=
                                            _mqttController.psig1sethigh.value
                                        ? Colors.red
                                        : textColor,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    Get.to(() => SuctionPressureSetting()),
                                child: Pressurewidget(
                                  limit:
                                      _mqttController.psiTobar.value ? 300 : 21,
                                  title:
                                      "${'suction'.tr} ${(_mqttController.psiTobar.value ? "(PSI)" : "(Bar)")} ",
                                  low: _mqttController.psig1sethigh.value
                                      .toStringAsFixed(0),
                                  setpoint: _mqttController.psig1sethigh.value
                                      .toString(),
                                  getColorLogic: (_) =>
                                      _mqttController.psig1.value <=
                                              _mqttController.psig1sethigh.value
                                          ? Colors.red
                                          : textColor,
                                ),
                              ),
                      if (_mqttController.isSuctionPressureVisible.value &&
                          _mqttController.isDischargePressureVisible.value)
                        SizedBox(width: shortestSide * 0.03),
                      if (_mqttController.isDischargePressureVisible.value)
                        _mqttController.isSuctionPressureVisible.value
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      Get.to(() => DischargePressureSetting()),
                                  child: Pressurewidget(
                                    limit: _mqttController.psiTobar.value
                                        ? 725
                                        : 50,
                                    title:
                                        "${'discharge'.tr} ${(_mqttController.psiTobar.value ? "(PSI)" : "(Bar)")} ",
                                    high: _mqttController.psig2setlow.value
                                        .toString(),
                                    setpoint: _mqttController.psig2setlow.value
                                        .toString(),
                                    getColorLogic: (_) => _mqttController
                                                .psig2.value >=
                                            _mqttController.psig2setlow.value
                                        ? Colors.red
                                        : textColor,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    Get.to(() => DischargePressureSetting()),
                                child: Pressurewidget(
                                  limit:
                                      _mqttController.psiTobar.value ? 725 : 50,
                                  title:
                                      "${'discharge'.tr} ${(_mqttController.psiTobar.value ? "(PSI)" : "(Bar)")} ",
                                  high: _mqttController.psig2setlow.value
                                      .toString(),
                                  setpoint: _mqttController.psig2setlow.value
                                      .toString(),
                                  getColorLogic: (_) =>
                                      _mqttController.psig2.value >=
                                              _mqttController.psig2setlow.value
                                          ? Colors.red
                                          : textColor,
                                ),
                              ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.02),
                  if (_mqttController.isOilPressureVisible.value)
                    GestureDetector(
                      onTap: () => Get.to(() => OilPressureSetting()),
                      child: Pressurewidget(
                        limit: _mqttController.psiTobar.value ? 725 : 50,
                        title:
                            "${'oil'.tr} ${(_mqttController.psiTobar.value ? "(PSI)" : "(Bar)")} ",
                        low: _mqttController.psig3sethigh.value.toString(),
                        setpoint: _mqttController.psig3sethigh.value.toString(),
                        getColorLogic: (_) => _mqttController.psig3.value <=
                                _mqttController.psig3sethigh.value
                            ? Colors.red
                            : textColor,
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
