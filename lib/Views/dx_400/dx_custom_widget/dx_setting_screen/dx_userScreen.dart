import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DxUserscreen extends StatefulWidget {
  const DxUserscreen({super.key});

  @override
  State<DxUserscreen> createState() => _DxUserscreenState();
}
class _DxUserscreenState extends State<DxUserscreen> {
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'faultResetSetting'.tr,
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Obx(
              () => DXRestartToggle(
                title: 'autoManualResetSwitch'.tr,
                value: _mqttController.dxisAutoSwitch.value,
                onTap: () async {
                  _mqttController.dxautoSwLoading.value = true;
                  final newValue = !_mqttController.dxisAutoSwitch.value;
                  await _mqttController.dxautoSwitch(newValue);
                  _mqttController.dxautoSwLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(height: 20),
            DXNumberAdjuster(
              title: "System Restart Delay",
              value: _mqttController.restartdelay,
              min: 0,
              max: 120,
            ),
            SizedBox(height: 20),
            DXNumberAdjuster(
              title: "System Start Delay",
              value: _mqttController.startdelay,
              min: 0,
              max: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class DXRestartToggle extends StatelessWidget {
  final bool value;
  final Future<bool> Function()? onTap;
  final String title;

  const DXRestartToggle({
    super.key,
    required this.value,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Container(
          width: Get.width * 0.95,
          height: Get.height * 0.21,
          padding: EdgeInsets.all(Get.width * 0.03),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.02,
                  horizontal: Get.width * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                  color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'manualReset'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    LoadSwitch(
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
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'autoReset'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DXNumberAdjuster extends StatefulWidget {
  final String title;
  final RxInt value;
  final int min;
  final int max;

  const DXNumberAdjuster({
    super.key,
    required this.title,
    required this.value,
    this.min = 0,
    this.max = 120,
  });

  @override
  State<DXNumberAdjuster> createState() => _DXNumberAdjusterState();
}

class _DXNumberAdjusterState extends State<DXNumberAdjuster> {
  final MqttController _mqttController = Get.find<MqttController>();

  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Container(
          width: Get.width * 0.95,
          height: Get.height * 0.21,
          padding: EdgeInsets.all(Get.width * 0.03),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.02,
                  horizontal: Get.width * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                  color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ➖ Decrement Button
                      IconButton(
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.red, size: 30),
                        onPressed: () {
                          _mqttController.isUserInteracting.value = true;
                          if (widget.value.value > widget.min)
                            widget.value.value--;
        
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.buildJsonPayloadDXPressure();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.isUserInteracting.value = false;
                            });
                          });
                        },
                      ),
                      // 🔢 Number Display
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '${widget.value.value}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      // ➕ Increment Button
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: Colors.green, size: 30),
                        onPressed: () {
                          _mqttController.isUserInteracting.value = true;
                          if (widget.value.value < widget.max)
                            widget.value.value++;
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 1), () {
                            _mqttController.buildJsonPayloadDXPressure();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              _mqttController.isUserInteracting.value = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
