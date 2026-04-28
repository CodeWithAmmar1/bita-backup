import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/rms/config_page_slider/config_page_slider.dart';
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
            SizedBox(
              height: 90,
            ),
            GestureDetector(
              onTap: () {
                _mqttcontroller.isUserInteracting.value = true;
              },
              child: Obx(
                () => SimpleSunkenButton(
                  isOn: power.value == 1,
                  size: Get.height * 0.30,
                  baseColor:
                      Get.isDarkMode ? const Color(0xFF202020) : Colors.white,
                  onTap: () {
                    power.value = power.value == 1 ? 0 : 1;
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
