import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class InputOutputChm extends StatelessWidget {
  const InputOutputChm({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final MqttController mqttController = Get.find<MqttController>();
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        title: Text(
          "Input Output",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "INPUT",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Circuit A",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.01,
                      vertical: Get.width * 0.005),
                  child: Container(
                    width: Get.width * 0.95,
                    padding: EdgeInsets.all(Get.width * 0.03),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      borderRadius: BorderRadius.circular(Get.width * 0.03),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Oil Switch",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.oilswA.value != 0
                                        ? "Open"
                                        : "Close",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Oil PSI",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.oilpsiA.value != 0
                                        ? "Open"
                                        : "Close",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Suction",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      mqttController.suctionA.value != 0
                                          ? "Open"
                                          : "Close",
                                      style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: Get.width * 0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Discharge",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.dischargeA.value != 0
                                        ? "Open"
                                        : "Close",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Circuit B",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.01,
                      vertical: Get.width * 0.005),
                  child: Container(
                    width: Get.width * 0.95,
                    padding: EdgeInsets.all(Get.width * 0.03),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      borderRadius: BorderRadius.circular(Get.width * 0.03),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Oil Switch",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.oilswB.value != 0
                                        ? "Open"
                                        : "Close",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Oil PSI",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.oilpsiB.value != 0
                                        ? "Open"
                                        : "Close",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Suction",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      mqttController.suctionB.value != 0
                                          ? "Open"
                                          : "Close",
                                      style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: Get.width * 0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.09,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Discharge",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.dischargeB.value != 0
                                        ? "Open"
                                        : "Close",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "OUTPUT",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Circuit A",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.01,
                      vertical: Get.width * 0.005),
                  child: Container(
                    width: Get.width * 0.95,
                    padding: EdgeInsets.all(Get.width * 0.03),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      borderRadius: BorderRadius.circular(Get.width * 0.03),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Star",
                                      style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.starA.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Delta",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.deltaA.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fan 1&2",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.fan1A.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fan 3&5",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.fan3A.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Circuit B",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.01,
                      vertical: Get.width * 0.005),
                  child: Container(
                    width: Get.width * 0.95,
                    padding: EdgeInsets.all(Get.width * 0.03),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      borderRadius: BorderRadius.circular(Get.width * 0.03),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Star",
                                      style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.starB.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Delta",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.deltaB.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fan 1&2",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.fan1B.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: baseSize * 0.08,
                          width: baseSize * 0.1,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Fan 3&5",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    mqttController.fan3B.value != 0
                                        ? "On"
                                        : "Off",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
