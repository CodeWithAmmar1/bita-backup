import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/telecome/status_widget_telecome/status_setting/tone_setting.dart';
import 'package:testappbita/Views/telecome/status_widget_telecome/status_setting/tthree_setting.dart';
import 'package:testappbita/Views/telecome/status_widget_telecome/status_setting/ttwo_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'dart:math' as math;

class StatusScreen extends StatelessWidget {
  StatusScreen({super.key});
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
            "ac_units_duty_times".tr,
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
                SizedBox(height: baseSize * 0.03),
                // Row 1
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.to(() => ToneSetting()),
                        child: Obx(() => StatusCard(
                              limit: 12,
                              title: 'ac_1_time'.tr,
                              unit: "Hr",
                              setpoint:
                                  _mqttController.tOneTel.value.toString(),
                              high: 'time_1'.tr,
                              getColorLogic: (pressure) =>
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(width: 12),
                    Obx(() {
                      return Expanded(
                        child: GestureDetector(
                            onTap: () => Get.to(() => TtwoSetting()),
                            child: StatusCard(
                              limit: 12,
                              title: 'ac_2_time'.tr,
                              unit: "Hr",
                              setpoint:
                                  _mqttController.tTwoTel.value.toString(),
                              high: 'time_2'.tr,
                              getColorLogic: (pressure) =>
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            )),
                      );
                    }),
                  ],
                ),

                GestureDetector(
                    onTap: () => Get.to(() => TthreeSetting()),
                    child: Obx(
                      () => StatusCard(
                        limit: 100,
                        title: 'overlap_delay'.tr,
                        unit: "Min",
                        setpoint: _mqttController.tThreeTel.value.toString(),
                        high: 'time_3'.tr,
                        getColorLogic: (pressure) =>
                            Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String setpoint;
  final String? high;
  final String? low;
  final int limit;
  final String unit;
  final Color Function(int temp)? getColorLogic;
  const StatusCard({
    super.key,
    required this.title,
    required this.setpoint,
    this.high,
    this.low,
    this.getColorLogic,
    required this.limit,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    int temp = int.parse(setpoint);
    Color pressureColor =
        getColorLogic != null ? getColorLogic!(temp) : Colors.white;
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: shortestSide * 0.42,
          height: isPortrait ? baseSize * 0.21 : baseSize * 0.22,
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: baseSize * 0.020,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: baseSize * 0.021),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: math.pi, // ⬅️ start from bottom
                    child: SizedBox(
                      height: shortestSide * 0.14,
                      width: shortestSide * 0.14,
                      child: CircularProgressIndicator(
                        value: (double.parse(setpoint) / limit),
                        strokeWidth: 4,
                        backgroundColor: Colors.grey[500],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF24C456),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${double.parse(setpoint).toInt()} $unit",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: pressureColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (low != null || high != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ThemeColor().actual,
                  ),
                  width: shortestSide * 1,
                  height: baseSize * 0.05,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (low != null)
                          Text(
                            low!,
                            style: TextStyle(
                              // fontSize: 10,
                              fontSize: baseSize * 0.016,
                              fontWeight: FontWeight.bold,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        if (high != null)
                          Text(
                            high!,
                            style: TextStyle(
                              // fontSize: 13,
                              fontSize: baseSize * 0.016,
                              fontWeight: FontWeight.bold,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
