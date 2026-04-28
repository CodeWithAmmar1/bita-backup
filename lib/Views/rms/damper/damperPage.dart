import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/Views/zone_master/custom_widget/custom_bottom.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'dart:async';

class DamperPage extends StatefulWidget {
  final String deviceId;
  const DamperPage({super.key, required this.deviceId});
  @override
  // ignore: library_private_types_in_public_api
  _DamperPageState createState() => _DamperPageState();
}

Timer? publishTimer;

class _DamperPageState extends State<DamperPage> {
  void _showBottomSheet(String title) {
    Get.bottomSheet(
      CustomBottomSheet( permission: false,),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  final MqttController _mqttcontroller = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return Obx(
      () => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor:
              Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
          appBar: AppBar(
            backgroundColor: ThemeColor().actual,
            centerTitle: true,
            title: Row(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/rms.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    "Damper",
                    style: TextStyle(
                      fontSize: 18,
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.air,
                            color: ThemeColor().actual,
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            _mqttcontroller.flapstate.value.toUpperCase(),
                            style: TextStyle(
                              fontSize: shortestSide * 0.04,
                              fontWeight: FontWeight.bold,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if ((_mqttcontroller.lastDamperValue.value < 5) ||
                      (_mqttcontroller.isOn.value == false))
                    SizedBox(
                      height: 20,
                    ),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if ((_mqttcontroller.lastDamperValue.value > 4) &&
                            (_mqttcontroller.isOn.value == true))
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: baseSize * 0.35,
                              angleRange: 300,
                              startAngle: 120,
                              customWidths: CustomSliderWidths(
                                trackWidth: baseSize * 0.008,
                                progressBarWidth: baseSize * 0.008,
                                handlerSize: baseSize * 0.015,
                              ),
                              customColors: CustomSliderColors(
                                trackColor: Colors.grey[500],
                                progressBarColors: [
                                  Color(0xFF24C48E),
                                  Color(0xFF24C456)
                                ],
                                dotColor: Color(0xFF24C48E),
                              ),
                            ),
                            min: (_mqttcontroller.lastDamperValue.value < 5)
                                ? 0
                                : 5,
                            max: 35,
                            initialValue: _mqttcontroller.lastDamperValue.value
                                .toDouble()
                                .clamp(0, 35),
                            onChangeStart: (_) {
                              _mqttcontroller.isUserInteracting.value = true;
                            },
                            onChange: (double value) {
                              _mqttcontroller.isUserInteracting.value = true;
                              _mqttcontroller.changeDamperValue(value);
                            },
                            onChangeEnd: (double value) {
                              publishTimer?.cancel();
                              publishTimer = Timer(Duration(seconds: 1), () {
                                _mqttcontroller.buildJsonPayloadRms();
                                publishTimer = Timer(Duration(seconds: 1), () {
                                  _mqttcontroller.isUserInteracting.value =
                                      false;
                                });
                              });
                            },
                          ),
                        Container(
                          width: baseSize * 0.56,
                          height: baseSize * 0.28,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Get.isDarkMode
                                    ? ThemeColor().actual.withValues(alpha: 0.8)
                                    : Colors.black26,
                                blurRadius: 20,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: _mqttcontroller.isConnected.value
                                    ? Color(0xFF24C48E)
                                    : Colors.red,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: baseSize * 0.12,
                                child: Text(
                                  _mqttcontroller.lastDamperValue.value < 5 ||
                                          _mqttcontroller.deviceConnections[
                                                  widget.deviceId] ==
                                              false ||
                                          !_mqttcontroller.isOn.value
                                      ? "--.-"
                                      : "${_mqttcontroller.lastDamperValue.value.round()}°C",
                                  style: TextStyle(
                                    fontFamily: 'DS-Digital',
                                    fontSize: shortestSide * 0.2,
                                    fontWeight: FontWeight.bold,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              _mqttcontroller
                                          .deviceConnections[widget.deviceId] ==
                                      false
                                  ? Text(
                                      '${"Room Temp.".tr} --.-°C',
                                      style: TextStyle(
                                        fontSize: shortestSide * 0.035,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    )
                                  : Text(
                                      _mqttcontroller.lastDamperValue.value < 5
                                          ? 'Thermostat Error'.tr
                                          : !_mqttcontroller.isOn.value
                                              ? "Power Off"
                                              : '${"Room Temp.".tr} ${_mqttcontroller.temperature}°C',
                                      style: TextStyle(
                                        fontSize: shortestSide * 0.035,
                                        color: (_mqttcontroller
                                                        .lastDamperValue.value <
                                                    5) ||
                                                (!_mqttcontroller.isOn.value)
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
                  if ((_mqttcontroller.lastDamperValue.value > 4) &&
                      (_mqttcontroller.isOn.value == true))
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _mqttcontroller.isUserInteracting.value = true;
                                if (_mqttcontroller.lastDamperValue.value > 5) {
                                  _mqttcontroller.lastDamperValue.value -= 1;
                                  _mqttcontroller.changeDamperValue(
                                      _mqttcontroller.lastDamperValue.value
                                          .toDouble());
                                  publishTimer?.cancel();
                                  publishTimer =
                                      Timer(Duration(seconds: 1), () {
                                    _mqttcontroller.buildJsonPayloadRms();
                                    _mqttcontroller.isUserInteracting.value =
                                        false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Get.isDarkMode
                                    ? ThemeColor().mode2Sec
                                    : ThemeColor().mode1Sec,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: shortestSide * 0.12,
                                    vertical: baseSize * 0.001),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Color(0xFF24C48E),
                              )),
                          Container(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            width: shortestSide * 0.28,
                            height: baseSize * 0.05,
                            child: Center(
                              child: Text(
                                'Set Point'.tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _mqttcontroller.isUserInteracting.value = true;
                                if (_mqttcontroller.lastDamperValue.value <
                                    35) {
                                  _mqttcontroller.lastDamperValue.value += 1;
                                  _mqttcontroller.changeDamperValue(
                                      _mqttcontroller.lastDamperValue.value
                                          .toDouble());
                                  publishTimer?.cancel();
                                  publishTimer =
                                      Timer(Duration(seconds: 1), () {
                                    _mqttcontroller.buildJsonPayloadRms();
                                    _mqttcontroller.isUserInteracting.value =
                                        false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Get.isDarkMode
                                    ? ThemeColor().mode2Sec
                                    : ThemeColor().mode1Sec,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                    horizontal: shortestSide * 0.12,
                                    vertical: baseSize * 0.001),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Color(0xFF24C48E),
                              )),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Mode".tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF24C48E),
                                ),
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: !_mqttcontroller.isSummer.value
                                    ? "summer".tr
                                    : "winter".tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "CFM".tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF24C48E),
                                ),
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text:
                                    "${_mqttcontroller.currentValue.toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: baseSize * 0.111,
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _mqttcontroller.isOn.value =
                                    !_mqttcontroller.isOn.value;
                              },
                              child: LoadSwitch(
                                height: baseSize * 0.048,
                                width: baseSize * 0.048,
                                value: _mqttcontroller.isOn.value,
                                future: () async {
                                  final newValue = !_mqttcontroller.isOn.value;
                                  _mqttcontroller.isOn.value = newValue;
                                 _mqttcontroller.buildJsonPayloadRms();
                                  await Future.delayed(
                                      Duration(milliseconds: 2000));
                                  return newValue;
                                },
                                onChange: (_) {},
                                onTap: (val) {
                                  log("damp switch change : $val");
                                },
                                animationDuration:
                                    const Duration(milliseconds: 1000),
                                curveIn: Curves.easeInBack,
                                curveOut: Curves.easeOutBack,
                                style: SpinStyle.material,
                                switchDecoration: (value, loading) =>
                                    BoxDecoration(
                                  color: value
                                      ? ThemeColor()
                                          .actual
                                          .withValues(alpha: 0.2)
                                      : Colors.red[100],
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: value
                                          ? ThemeColor()
                                              .actual
                                              .withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                spinColor: (value) =>
                                    value ? ThemeColor().actual : Colors.grey,
                                spinStrokeWidth: 3,
                                thumbDecoration: (value, loading) =>
                                    BoxDecoration(
                                  color: _mqttcontroller.isOn.value
                                      ? Color(0xFF24C48E)
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: value
                                          ? ThemeColor()
                                              .actual
                                              .withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.power_settings_new,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 6),
                      Text(
                        "Power".tr,
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showBottomSheet("Season"),
                    child: _buildIconContainer(
                      context,
                      Icons.dashboard,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                      "Mode",
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () =>
                        _mqttcontroller.showPasswordDialog(context ,false),
                    child: _buildIconContainer(
                      context,
                      Icons.tune,
                      Colors.grey,
                      Colors.grey.shade200,
                      "CFM",
                      Get.isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildIconContainer(
  BuildContext context,
  IconData icon,
  Color iconColor,
  Color color,
  String text,
  Color txtcolor, {
  bool showTick = false,
  Color tickColor = Colors.grey,
}) {
  final media = MediaQuery.of(context);
  final isPortrait = media.orientation == Orientation.portrait;
  final baseSize = isPortrait ? media.size.height : media.size.width;
  final shortestSide = media.size.shortestSide;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: baseSize * 0.05,
            width: shortestSide * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(icon, color: iconColor),
          ),
          if (showTick)
            Positioned(
              bottom: -5,
              right: -5,
              child: Icon(
                Icons.check_circle,
                color: tickColor,
                size: 18,
              ),
            ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        text.tr,
        style: TextStyle(
          color: txtcolor,
        ),
      ),
    ],
  );
}
