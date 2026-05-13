import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/setpoint_setting/setpoint_widget.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SystemsetpointChmB extends StatefulWidget {
  const SystemsetpointChmB({super.key});

  @override
  State<SystemsetpointChmB> createState() => _SystemsetpointChmBState();
}

class _SystemsetpointChmBState extends State<SystemsetpointChmB> {
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'System Setpoints',
            style: TextStyle(
                fontSize: Get.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => SetpointWidget(
                          title: "Suction Pressure",
                          unit: "PSI",
                          minValue: 0,
                          maxValue: 100,
                          value: _mqttController.sucPressurespB,
                          onPublish: () {
                            _mqttController.buildJsonPayloadCiruitB();
                          },
                        ),
                      ),
                      child: Obx(() => StatusCard(
                            limit: 100,
                            title: 'Suction Pressure'.tr,
                            unit: "PSI",
                            setpoint:
                                _mqttController.sucPressurespB.value.toString(),
                            getColorLogic: (pressure) =>
                                Get.isDarkMode ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => Get.to(
                              () => SetpointWidget(
                                title: "Discharge Pressure",
                                unit: "PSI",
                                minValue: 150,
                                maxValue: 700,
                                value: _mqttController.disPressurespB,
                                onPublish: () {
                                  _mqttController.buildJsonPayloadCiruitB();
                                },
                              ),
                            ),
                        child: StatusCard(
                          limit: 700,
                          title: 'Discharge Pressure'.tr,
                          unit: "PSI",
                          setpoint:
                              _mqttController.disPressurespB.value.toString(),
                          getColorLogic: (pressure) =>
                              Get.isDarkMode ? Colors.white : Colors.black,
                        )),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => SetpointWidget(
                          title: "Suction Temp",
                          unit: "°C",
                          minValue: -2,
                          maxValue: 30,
                          value: _mqttController.sucTempspB,
                          onPublish: () {
                            _mqttController.buildJsonPayloadCiruitB();
                          },
                        ),
                      ),
                      child: Obx(() => StatusCard(
                            limit: 30,
                            title: "Suction Temp",
                            unit: "°C",
                            setpoint:
                                _mqttController.sucTempspB.value.toString(),
                            getColorLogic: (pressure) =>
                                Get.isDarkMode ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => Get.to(
                              () => SetpointWidget(
                                title: "Discharge Temp",
                                unit: "°C",
                                minValue: 50,
                                maxValue: 100,
                                value: _mqttController.disTempspB,
                                onPublish: () {
                                  _mqttController.buildJsonPayloadCiruitB();
                                },
                              ),
                            ),
                        child: StatusCard(
                          limit: 100,
                          title: "Discharge Temp",
                          unit: "°C",
                          setpoint: _mqttController.disTempspB.value.toString(),
                          getColorLogic: (pressure) =>
                              Get.isDarkMode ? Colors.white : Colors.black,
                        )),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => SetpointWidget(
                          title: "Low Spray Temp",
                          unit: "°C",
                          minValue: -10,
                          maxValue: 50,
                          value: _mqttController.lowSprayTempspB,
                          onPublish: () {
                            _mqttController.buildJsonPayloadCiruitB();
                          },
                        ),
                      ),
                      child: Obx(() => StatusCard(
                            limit: 50,
                            title: "Low Spray Temp",
                            unit: "°C",
                            setpoint: _mqttController.lowSprayTempspB.value
                                .toString(),
                            getColorLogic: (pressure) =>
                                Get.isDarkMode ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => Get.to(
                              () => SetpointWidget(
                                title: "Super Heat",
                                unit: "°F",
                                minValue: 2,
                                maxValue: 20,
                                value: _mqttController.superHeatspB,
                                onPublish: () {
                                  _mqttController.buildJsonPayloadCiruitB();
                                },
                              ),
                            ),
                        child: StatusCard(
                          limit: 20,
                          title: "Super Heat",
                          unit: "°F",
                          setpoint:
                              _mqttController.superHeatspB.value.toString(),
                          getColorLogic: (pressure) =>
                              Get.isDarkMode ? Colors.white : Colors.black,
                        )),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () => Get.to(
                              () => SetpointWidget(
                                title: "Current High",
                                unit: "A",
                                minValue: 0,
                                maxValue: 100,
                                value: _mqttController.amperespB,
                                onPublish: () {
                                  _mqttController.buildJsonPayloadCiruitB();
                                },
                              ),
                            ),
                        child: StatusCard(
                          limit: 100,
                          title: "Current High",
                          unit: "A",
                          setpoint: _mqttController.amperespB.value.toString(),
                          getColorLogic: (pressure) =>
                              Get.isDarkMode ? Colors.white : Colors.black,
                        )),
                  ),
                   SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => Get.to(
                                () => SetpointWidget(
                                  title: "Oil Pressure",
                                  unit: "PSI",
                                  minValue: 0,
                                  maxValue: 100,
                                  value: _mqttController.oilPressurespB,
                                  onPublish: () {
                                    _mqttController.buildJsonPayloadCiruitB();
                                  },
                                ),
                              ),
                          child: StatusCard(
                            limit: 100,
                            title: "Oil Pressure",
                            unit: "PSI",
                            setpoint:
                                _mqttController.oilPressurespB.value.toString(),
                            getColorLogic: (pressure) =>
                                Get.isDarkMode ? Colors.white : Colors.black,
                          )),
                    )
                ],
              )
            ],
          ),
        ));
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String setpoint;
  final int limit;
  final String unit;
  final Color Function(int temp)? getColorLogic;
  const StatusCard({
    super.key,
    required this.title,
    required this.setpoint,
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
                      Text(
                        "Set Point: ${double.parse(setpoint).toInt()} $unit",
                        style: TextStyle(
                          fontSize: baseSize * 0.016,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
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
