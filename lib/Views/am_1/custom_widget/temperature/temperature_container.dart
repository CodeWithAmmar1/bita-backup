import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperature.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class TemperatureContainerAm1 extends StatelessWidget {
  final RxBool isReturn = true.obs;
  final String deviceId;
  final MqttController _mqttController = Get.find<MqttController>();
  TemperatureContainerAm1({super.key, required this.deviceId});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.01),
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
                  Row(
                    children: [
                      Icon(Icons.thermostat,
                          color: Colors.red, size: Get.width * 0.07),
                      SizedBox(width: Get.width * 0.015),
                      GestureDetector(
                          onTap: () {
                            _mqttController.isUserInteracting.value = true;
                            _mqttController.ftoC1.toggle();
                            publishTimer?.cancel();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.buildJsonPayloadAm1Sensor();
                              log("Temperature: ${_mqttController.ftoC1.value}");
                              _mqttController.isUserInteracting.value = false;
                            });
                          },
                          child: Obx(() => Text(
                                _mqttController.ftoC1.value
                                    ? 'systemTempC'.tr
                                    : 'systemTempF'.tr,
                                style: TextStyle(
                                  fontSize: Get.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ))),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => TemperatureAm1()),
                    child: Icon(
                      Icons.settings,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      size: Get.width * 0.065,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.015),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Obx(() => GestureDetector(
                          onTap: () => isReturn.toggle(),
                          child: TemperatureWidgetAm1(
                            title: isReturn.value ? 'return'.tr : 'supply'.tr,
                            temperature: _mqttController
                                        .deviceConnections[deviceId] ??
                                    false
                                ? isReturn.value
                                    ? _mqttController.ftoC1.value
                                        ? _mqttController.returnlinetemp.value ==
                                                888.0
                                            ? "888"
                                            : _mqttController.returnlinetemp.value ==
                                                    999.0
                                                ? "None"
                                                : _mqttController
                                                    .returnlinetemp.value
                                                    .toString()
                                        : _mqttController.returnlinetempF.value ==
                                                888.0
                                            ? "888"
                                            : _mqttController.returnlinetempF
                                                        .value ==
                                                    999.0
                                                ? "None"
                                                : _mqttController
                                                    .returnlinetempF.value
                                                    .toString()
                                    : _mqttController.ftoC1.value
                                        ? _mqttController.supplylinetemp.value ==
                                                888.0
                                            ? "888"
                                            : _mqttController.supplylinetemp.value ==
                                                    999.0
                                                ? "None"
                                                : _mqttController
                                                    .supplylinetemp.value
                                                    .toString()
                                        : _mqttController.supplylinetempF.value ==
                                                888.0
                                            ? "888"
                                            : _mqttController.supplylinetempF
                                                        .value ==
                                                    999.0
                                                ? "None"
                                                : _mqttController
                                                    .supplylinetempF.value
                                                    .toString()
                                : "--",
                            getColorLogic: () {
                              if (isReturn.value) {
                                return (_mqttController.tempsphigh.value <=
                                            _mqttController
                                                .returnlinetemp.value) ||
                                        (_mqttController.returnlinetemp.value ==
                                            888.0) ||
                                        (_mqttController
                                                .returnlinetempF.value ==
                                            888.0) ||
                                        (_mqttController.returnlinetemp.value ==
                                            999.0) ||
                                        (_mqttController
                                                .returnlinetempF.value ==
                                            999.0)
                                    ? Colors.red
                                    : Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black;
                              } else {
                                return (_mqttController.supplylinetempF.value == 888.0) ||
                                        (_mqttController.supplylinetemp.value ==
                                            888.0) ||
                                        (_mqttController
                                                .supplylinetempF.value ==
                                            999.0) ||
                                        (_mqttController.supplylinetemp.value ==
                                            999.0)
                                    ? Colors.red
                                    : Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black;
                              }
                            },
                          ),
                        )),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: TemperatureWidgetAm1(
                      title: 'suction'.tr,
                      temperature: _mqttController
                                  .deviceConnections[deviceId] ??
                              false
                          ? _mqttController.ftoC1.value
                              ? _mqttController.suctionlinetemp.value == 888.0
                                  ? "888"
                                  : _mqttController.suctionlinetemp.value ==
                                          999.0
                                      ? "None"
                                      : _mqttController.suctionlinetemp.value
                                          .toString()
                              : _mqttController.suctionlinetempF.value == 888.0
                                  ? "888"
                                  : _mqttController.suctionlinetempF.value ==
                                          999.0
                                      ? "None"
                                      : _mqttController.suctionlinetempF.value
                                          .toString()
                          : "--",
                      getColorLogic: () => (_mqttController
                                      .suctionlinetemp.value <=
                                  _mqttController.tempsp2.value) ||
                              (_mqttController.suctionlinetemp.value ==
                                  888.0) ||
                              (_mqttController.suctionlinetempF.value ==
                                  888.0) ||
                              (_mqttController.suctionlinetemp.value ==
                                  999.0) ||
                              (_mqttController.suctionlinetempF.value == 999.0)
                          ? Colors.red
                          : Get.isDarkMode
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.015),
                  Expanded(
                    child: TemperatureWidgetAm1(
                      title: 'discharge'.tr,
                      temperature: _mqttController
                                  .deviceConnections[deviceId] ??
                              false
                          ? _mqttController.ftoC1.value
                              ? _mqttController.dischargelinetemp.value == 888.0
                                  ? "888"
                                  : _mqttController.dischargelinetemp.value ==
                                          999.0
                                      ? "None"
                                      : _mqttController.dischargelinetemp.value
                                          .toString()
                              : _mqttController.dischargelinetempF.value ==
                                      888.0
                                  ? "888"
                                  : _mqttController.dischargelinetempF.value ==
                                          999.0
                                      ? "None"
                                      : _mqttController.dischargelinetempF.value
                                          .toString()
                          : "--",
                      getColorLogic: () =>
                          (_mqttController.dischargelinetemp.value >=
                                      _mqttController.tempsp1.value) ||
                                  (_mqttController.dischargelinetemp.value ==
                                      888.0) ||
                                  (_mqttController.dischargelinetempF.value ==
                                      888.0) ||
                                  (_mqttController.dischargelinetemp.value ==
                                      999.0) ||
                                  (_mqttController.dischargelinetempF.value ==
                                      999.0)
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

class TemperatureWidgetAm1 extends StatelessWidget {
  final String title;
  final String temperature;
  final Color Function()? getColorLogic;

  const TemperatureWidgetAm1({
    required this.title,
    required this.temperature,
    super.key,
    this.getColorLogic,
  });

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
        ],
      ),
    );
  }
}
