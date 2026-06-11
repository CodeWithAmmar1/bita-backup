import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CircuitSelectionSetting extends StatelessWidget {
  final bool permission;
  CircuitSelectionSetting({super.key, required this.permission});
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'Circuit Settings',
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
              if (permission)
            SizedBox(height: 20),
              if (permission)
            Obx(
              () => RestartToggleDX(
                leftText: 'Lead'.tr,
                rightText: 'Lag'.tr,
                title: 'Circuit A'.tr,
                value: _mqttController.leadlagASwitch.value,
                onTap: () async {
                  _mqttController.leadLagASwLoading.value = true;
                  final newValue = !_mqttController.leadlagASwitch.value;
                  await _mqttController.leadLagA(newValue);
                  _mqttController.leadLagASwLoading.value = false;
                  return newValue;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DxNumberAdj(permission: permission,
              unit: "Sec",
              title: "Start Delay",
              value: _mqttController.dmStartA,
              min: 0,
              max: 600,
            ),
            SizedBox(
              height: 10,
            ),
                     if (permission)
            DXNumberAdjuster(
              unit: "°C",
              title: "Step Size",
              value: _mqttController.dmStepSizeA,
              min: 0.1,
              max: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}

class DxNumberAdj extends StatefulWidget {
  final bool permission;
  final String title;
  final RxInt value;
  final int min;
  final int max;
  final String unit;

  const DxNumberAdj({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.unit, required this.permission,
  });

  @override
  State<DxNumberAdj> createState() => _DxNumberAdjState();
}

class _DxNumberAdjState extends State<DxNumberAdj> {
  final MqttController _mqttController = Get.find<MqttController>();
  Timer? publishTimer;
  Timer? _holdTimer;

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
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
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
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ➖ Decrement Button
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
                            if (widget.permission) {
                                _mqttController.buildJsonPayloadCiruitA();
                            } else {
                                _mqttController.buildJsonPayloadCHMCiruitA();
                            }
                          
                            publishTimer =
                                Timer(const Duration(seconds: 1), () {
                              _mqttController.isUserInteracting.value = false;
                            });
                          });
                        },
                        onTap: () {
                          _mqttController.isUserInteracting.value = true;
                          if (widget.value.value > widget.min)
                            widget.value.value--;
                          publishTimer?.cancel();
                          publishTimer = Timer(const Duration(seconds: 1), () {
                          if (widget.permission) {
                                _mqttController.buildJsonPayloadCiruitA();
                            } else {
                                _mqttController.buildJsonPayloadCHMCiruitA();
                            }
                            publishTimer =
                                Timer(const Duration(seconds: 1), () {
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

                      // 🔢 Number Display (🟢 UPDATED TO OPEN SHEET)
                      GestureDetector(
                        onTap: () => showNumberInputSheet(
                            widget.min, widget.max), // 🟢 NEW
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '${widget.value.value} ${widget.unit}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // ➕ Increment Button
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
                           if (widget.permission) {
                                _mqttController.buildJsonPayloadCiruitA();
                            } else {
                                _mqttController.buildJsonPayloadCHMCiruitA();
                            }
                            publishTimer =
                                Timer(const Duration(seconds: 1), () {
                              _mqttController.isUserInteracting.value = false;
                            });
                          });
                        },
                        onTap: () {
                          _mqttController.isUserInteracting.value = true;
                          if (widget.value.value < widget.max)
                            widget.value.value++;
                          publishTimer?.cancel();
                          publishTimer = Timer(const Duration(seconds: 1), () {
                          if (widget.permission) {
                                _mqttController.buildJsonPayloadCiruitA();
                            } else {
                                _mqttController.buildJsonPayloadCHMCiruitA();
                            }
                            publishTimer =
                                Timer(const Duration(seconds: 1), () {
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
        ),
      ),
    );
  }

  // 🟢 NEW: Function to show bottom sheet for manual input
  showNumberInputSheet(int min, int max) {
    final TextEditingController inputController = TextEditingController(
      text: widget.value.value.toString(),
    );

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter a number (${widget.min} - ${widget.max})",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter value",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor().actual,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final input = int.tryParse(inputController.text);
                if (input != null &&
                    input >= widget.min &&
                    input <= widget.max) {
                  widget.value.value = input;
               if (widget.permission) {
                                _mqttController.buildJsonPayloadCiruitA();
                            } else {
                                _mqttController.buildJsonPayloadCHMCiruitA();
                            }
                  Get.back();
                } else {
                  Get.snackbar(
                    "Invalid Input",
                    "Please enter a number between 0 and 60",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(10),
                  );
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DXNumberAdjuster extends StatefulWidget {
  final String title;
  final RxDouble value;
  final double min;
  final double max;
  final String unit;

  const DXNumberAdjuster({
    super.key,
    required this.title,
    required this.value,
    this.min = 0.1,
    this.max = 3.0,
    required this.unit,
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
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
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
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ➖ Decrement Button
                      GestureDetector(
                        onTap: () {
                          _mqttController.isUserInteracting.value = true;
                          if (widget.value.value > widget.min)
                            widget.value.value = (widget.value.value - 0.1)
                                .clamp(widget.min, widget.max);
                          publishTimer?.cancel();
                          publishTimer = Timer(const Duration(seconds: 1), () {
                      
                                _mqttController.buildJsonPayloadCiruitA();
                          
                            publishTimer =
                                Timer(const Duration(seconds: 1), () {
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

                      // 🔢 Number Display (🟢 UPDATED TO OPEN SHEET)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '${widget.value.value.toStringAsFixed(1)} ${widget.unit}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),

                      // ➕ Increment Button
                      GestureDetector(
                        onTap: () {
                          _mqttController.isUserInteracting.value = true;
                          if (widget.value.value < widget.max)
                            widget.value.value = (widget.value.value + 0.1)
                                .clamp(widget.min, widget.max);
                          publishTimer?.cancel();
                          publishTimer = Timer(const Duration(seconds: 1), () {
                        
                                _mqttController.buildJsonPayloadCiruitA();
                           
                            publishTimer =
                                Timer(const Duration(seconds: 1), () {
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
        ),
      ),
    );
  }
}

class RestartToggleDX extends StatelessWidget {
  final bool value;
  final Future<bool> Function()? onTap;
  final String title;
  final String rightText;
  final String leftText;

  const RestartToggleDX({
    super.key,
    required this.value,
    required this.onTap,
    required this.title,
    required this.rightText,
    required this.leftText,
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
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
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
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      leftText,
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
                      onTap: (val) {},
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
                      rightText,
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
