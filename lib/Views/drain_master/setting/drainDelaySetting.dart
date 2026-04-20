import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Draindelaysetting extends StatelessWidget {
  Draindelaysetting({super.key});
  final MqttController mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF24C48E),
        title: Text(
          "Drain Delay Setting",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: Get.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
        child: DMNumberAdjuster(
          title: "System Delay",
          value: mqttController.wtcdelay,
          min: 1,
          max: 10,
        ),
      ),
    );
  }
}

class DMNumberAdjuster extends StatefulWidget {
  final String title;
  final RxInt value;
  final int min;
  final int max;

  const DMNumberAdjuster({
    super.key,
    required this.title,
    required this.value,
    this.min = 1,
    this.max = 10,
  });

  @override
  State<DMNumberAdjuster> createState() => _DMNumberAdjusterState();
}

class _DMNumberAdjusterState extends State<DMNumberAdjuster> {
  final MqttController _mqttController = Get.find<MqttController>();
  Timer? publishTimer;
  Timer? _holdTimer;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              vertical: Get.height * 0.025,
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
                  GestureDetector(
                    onLongPressStart: (_) {
                      _mqttController.isUserInteracting.value = true;
                      _holdTimer = Timer.periodic(
                          const Duration(milliseconds: 50), (timer) {
                        if (widget.value.value > widget.min) {
                          widget.value.value--;
                        } else {
                          timer.cancel();
                        }
                      });
                    },
                    onLongPressEnd: (_) {
                      _holdTimer?.cancel();
                      publishTimer?.cancel();
                      publishTimer = Timer(const Duration(seconds: 1), () {
                        _mqttController.buildJsonPayloadDM();
                        publishTimer = Timer(const Duration(seconds: 1), () {
                          _mqttController.isUserInteracting.value = false;
                        });
                      });
                    },
                    onTap: () {
                      _mqttController.isUserInteracting.value = true;
                      if (widget.value.value > widget.min) widget.value.value--;
                      publishTimer?.cancel();
                      publishTimer = Timer(const Duration(seconds: 1), () {
                        _mqttController.buildJsonPayloadDM();
                        publishTimer = Timer(const Duration(seconds: 1), () {
                          _mqttController.isUserInteracting.value = false;
                        });
                      });
                    },
                    child: Icon(Icons.remove_circle,
                        color: Get.isDarkMode
                            ? ThemeColor().mode1Sec
                            : ThemeColor().mode2Sec,
                        size: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${widget.value.value} Sec',
                      style: TextStyle(
                        fontSize: 18,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onLongPressStart: (_) {
                      _mqttController.isUserInteracting.value = true;
                      _holdTimer = Timer.periodic(
                          const Duration(milliseconds: 50), (timer) {
                        if (widget.value.value < widget.max) {
                          widget.value.value++;
                        } else {
                          timer.cancel();
                        }
                      });
                    },
                    onLongPressEnd: (_) {
                      _holdTimer?.cancel();
                      publishTimer?.cancel();
                      publishTimer = Timer(const Duration(seconds: 1), () {
                        _mqttController.buildJsonPayloadDM();
                        publishTimer = Timer(const Duration(seconds: 1), () {
                          _mqttController.isUserInteracting.value = false;
                        });
                      });
                    },
                    onTap: () {
                      _mqttController.isUserInteracting.value = true;
                      if (widget.value.value < widget.max) widget.value.value++;
                      publishTimer?.cancel();
                      publishTimer = Timer(const Duration(seconds: 1), () {
                        _mqttController.buildJsonPayloadDM();
                        publishTimer = Timer(const Duration(seconds: 1), () {
                          _mqttController.isUserInteracting.value = false;
                        });
                      });
                    },
                    child: Icon(Icons.add_circle,
                        color: Get.isDarkMode
                            ? ThemeColor().mode1Sec
                            : ThemeColor().mode2Sec,
                        size: 30),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
