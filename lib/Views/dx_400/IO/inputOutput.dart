import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';

class Inputoutput extends StatelessWidget {
  Inputoutput({super.key});
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Output',
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: ThemeColor().actual,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "INPUT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.condenserOl.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.condenserOl.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Condenser OL',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.compressorOl.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.compressorOl.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Compressor OL',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.lps.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.lps.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'LPS',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.hps.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.hps.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'HPS',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.ops.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.ops.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'OPS',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.innerFanFeedback.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.innerFanFeedback.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'inner Fan FB',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.compressorFeedback.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  _mqttController.compressorFeedback.value == 1
                                      ? const Color.fromARGB(255, 133, 224, 136)
                                          .withOpacity(0.6)
                                      : const Color.fromARGB(255, 224, 105, 96)
                                          .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Compressor FB',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.heaterFeedback.value == 1
                              ? Colors.green
                              : Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.heaterFeedback.value == 1
                                  ? const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                  : const Color.fromARGB(255, 224, 105, 96)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Heater FB',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              "OUTPUT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.condenserFan.value == 1
                              ? Colors.red
                              : Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.condenserFan.value == 1
                                  ? const Color.fromARGB(255, 224, 105, 96)
                                  : const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Condenssor Fan',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mqttController.compressor.value == 1
                              ? Colors.red
                              : Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.compressor.value == 1
                                  ? const Color.fromARGB(255, 224, 105, 96)
                                  : const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Compressor',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:_mqttController.innerFan.value == 1
                                  ? Colors.red : Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.innerFan.value == 1
                                  ? const Color.fromARGB(255, 224, 105, 96)
                                  : const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inner Fan',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:_mqttController.heater.value == 1
                                  ? Colors.red : Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: _mqttController.heater.value == 1
                                  ? const Color.fromARGB(255, 224, 105, 96)
                                  : const Color.fromARGB(255, 133, 224, 136)
                                      .withOpacity(0.6)
                                      .withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Heater',
                      style: TextStyle(
                        fontSize: 10,fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
