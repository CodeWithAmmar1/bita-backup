import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class ConfigPageSlider extends StatefulWidget {
  final String title;
  final String image;
  final String heading;
  final RxInt power;
  final RxDouble currentValue;
  const ConfigPageSlider(
      {super.key,
      required this.title,
      required this.image,
      required this.heading,
      required this.power,
      required this.currentValue});

  @override
  State<ConfigPageSlider> createState() => _ConfigPageState();
}

final MqttController _mqttcontroller = Get.find<MqttController>();

// double _value = 0.5;

class _ConfigPageState extends State<ConfigPageSlider> {
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
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
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
                widget.title,
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
                  widget.power.value = widget.power.value == 1 ? 0 : 1;
                  _mqttcontroller.buildJsonPayloadRms();
                },
                child: Image.asset(
                  Get.isDarkMode
                      ? (widget.power.value == 1
                          ? "assets/images/buttondarkon.png"
                          : "assets/images/buttondarkoff.png")
                      : (widget.power.value == 1
                          ? "assets/images/buttonlighton.png"
                          : "assets/images/buttonlightoff.png"),
                  width: Get.width,
                  height: Get.height * 0.55,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.heading,
                    style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode ? Colors.white : Colors.black,
                        BlendMode.srcIn),
                    child: Image.asset(
                      widget.image,
                      width: 80,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey[400],
                    trackHeight: 6.0,
                    thumbColor: Colors.green,
                    overlayColor: Colors.green.withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 22.0,
                    ),
                  ),
                  child: Slider(
                      activeColor: ThemeColor().actual,
                      value: widget.currentValue.value,
                      min: 10,
                      max: 100,
                      divisions: 100,
                      label: widget.currentValue.toStringAsFixed(0),
                      onChanged: (double value) {
                        widget.currentValue.value =
                            double.parse(value.toStringAsFixed(0));
                      },
                      onChangeEnd: (double value) {
                        _mqttcontroller.buildJsonPayloadRms();
                      }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.arrow_drop_down_sharp,
                          color: Colors.green, size: 50),
                      Text(
                        "LOW",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.arrow_drop_down_sharp,
                          color: Colors.green, size: 50),
                      Text(
                        "MEDIUM",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.arrow_drop_down_sharp,
                          color: Colors.green, size: 50),
                      Text(
                        "HIGH",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
