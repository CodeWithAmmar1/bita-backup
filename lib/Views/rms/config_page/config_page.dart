import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class ConfigPage extends StatelessWidget {
  final RxInt power;
  final String title;

  ConfigPage({super.key, required this.title, required this.power});
  final MqttController _mqttcontroller = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColor().actual,
        title: Row(
          children: [
            Image.asset("assets/images/rms.png", width: 40, height: 40),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 5,
              width: Get.width * 0.8,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            Obx(
              () => GestureDetector(
                onTap: () {
                  power.value = power.value == 1 ? 0 : 1;
                  _mqttcontroller.buildJsonPayloadRms();
                },
                child: Image.asset(
                  Get.isDarkMode
                      ? (power.value == 1
                          ? "assets/images/buttondarkon.png"
                          : "assets/images/buttondarkoff.png")
                      : (power.value == 1
                          ? "assets/images/buttonlighton.png"
                          : "assets/images/buttonlightoff.png"),
                  width: Get.width,
                  height: Get.height * 0.55,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
