import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class Motor extends StatelessWidget {
  final RxBool isReturn = true.obs;
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  Motor({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.02),
      child: Container(
        width: Get.width * 0.95,
        padding: EdgeInsets.all(Get.width * 0.03),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          borderRadius: BorderRadius.circular(Get.width * 0.03),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(Icons.thermostat,
                        color: Colors.red, size: Get.width * 0.07),
                    SizedBox(width: Get.width * 0.015),
                    GestureDetector(
                      onTap: () {
                        _mqttController.isUserInteracting.value = true;
                        _mqttController.dxftoC.toggle();
                        publishTimer?.cancel();
                        publishTimer = Timer(Duration(seconds: 1), () {
                          _mqttController.buildJsonPayloadDXPressure();
                          log("Temperature: ${_mqttController.dxftoC.value}");
                          _mqttController.isUserInteracting.value = false;
                        });
                      },
                      child: Text(
                        'Motor Status'.tr,
                        style: TextStyle(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: DXMiniTemperatureWidget(
                      value: _mqttController.r3swDXM.value,
                      onTap: () async {
                        _mqttController.dxmR3SwLoading.value = true;
                        final newValue = !_mqttController.r3swDXM.value;
                        await _mqttController.dxmR3Switch(newValue);
                        _mqttController.dxmR3SwLoading.value = false;
                        return newValue;
                      },
                      title: 'Unit'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? _mqttController.r3statusDXM.value == 1
                                  ? "on".tr
                                  : "off".tr
                              : "--",
                      getColorLogic: () =>
                          _mqttController.r3statusDXM.value == 0
                              ? Colors.red
                              : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: Obx(() => DXMiniTemperatureWidget(
                          value: _mqttController.r1swDXM.value,
                          onTap: () async {
                            _mqttController.dxmR1SwLoading.value = true;
                            final newValue = !_mqttController.r1swDXM.value;
                            await _mqttController.dxmR1Switch(newValue);
                            _mqttController.dxmR1SwLoading.value = false;
                            return newValue;
                          },
                          title: 'Evaporation'.tr,
                          temperature:
                              _mqttController.deviceConnections[deviceId] ??
                                      false
                                  ? _mqttController.r1statusDXM.value == 1
                                      ? "on".tr
                                      : "off".tr
                                  : "--",
                          getColorLogic: () =>
                              _mqttController.r1statusDXM.value == 0
                                  ? Colors.red
                                  : Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                        )),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: DXMiniTemperatureWidget(
                      value: _mqttController.r2swDXM.value,
                      onTap: () async {
                        _mqttController.dxmR2SwLoading.value = true;
                        final newValue = !_mqttController.r2swDXM.value;
                        await _mqttController.dxmR2Switch(newValue);
                        _mqttController.dxmR2SwLoading.value = false;
                        return newValue;
                      },
                      title: 'Autowash'.tr,
                      temperature:
                          _mqttController.deviceConnections[deviceId] ?? false
                              ? _mqttController.r2statusDXM.value == 1
                                  ? "on".tr
                                  : "off".tr
                              : "--",
                      getColorLogic: () =>
                          _mqttController.r2statusDXM.value == 0
                              ? Colors.red
                              : Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DXMiniTemperatureWidget extends StatelessWidget {
  final bool value;
  final Future<bool> Function()? onTap;
  final String title;
  final String temperature;
  final Color Function()? getColorLogic;

  DXMiniTemperatureWidget({
    required this.title,
    required this.temperature,
    super.key,
    this.getColorLogic,
    required this.value,
    this.onTap,
  });
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final tempColor = getColorLogic != null ? getColorLogic!() : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.015,
        horizontal: Get.width * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.width * 0.02),
        color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.040,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: Get.height * 0.005),
          Text(
            temperature.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.bold,
              color: tempColor,
            ),
          ),
          Obx(() {
            // Return an empty widget (SizedBox) if the condition isn't met
            if (_mqttController.modeDXM.value) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoadSwitch(
                height: Get.height * 0.038,
                width: Get.height * 0.08,
                value: value,
                future: onTap,
                onChange: (_) {},
                onTap: (val) {
                  log("Tapped while value is $val");
                },
                animationDuration: const Duration(milliseconds: 300),
                curveIn: Curves.easeInBack,
                curveOut: Curves.easeOutBack,
                style: SpinStyle.material,
                switchDecoration: (value, loading) => BoxDecoration(
                  color: value
                      ? ThemeColor().actual.withValues(alpha: 0.2)
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: value
                          ? ThemeColor().actual.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                spinColor: (value) => value
                    ? ThemeColor().actual
                    : const Color.fromARGB(255, 255, 77, 77),
                spinStrokeWidth: 3,
                thumbDecoration: (value, loading) => BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: value
                          ? ThemeColor().actual.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
