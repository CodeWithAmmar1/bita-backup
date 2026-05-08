import 'dart:async';
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

Timer? publishTimer;

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                  SizedBox(
                    height: 90,
                  ),
                  Obx(
                    () => SimpleSunkenButton(
                      isOn: widget.power.value == 1,
                      size: Get.height * 0.30,
                      baseColor: Get.isDarkMode
                          ? const Color(0xFF202020)
                          : Colors.white,
                      onTap: () {
                         _mqttcontroller.isUserInteracting.value = true;
                    publishTimer = Timer(Duration(seconds: 1), () {
                      widget.power.value = widget.power.value == 1 ? 0 : 1;
                      _mqttcontroller.buildJsonPayloadRms();
                      _mqttcontroller.isUserInteracting.value = false;
                    });
                      },
                    ),
                  ),
                ]),
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
        ],
      ),
    );
  }
}

class SimpleSunkenButton extends StatefulWidget {
  final bool isOn;
  final VoidCallback onTap;
  final double size;
  final Color baseColor; // e.g., Colors.black or Colors.white

  const SimpleSunkenButton({
    Key? key,
    required this.isOn,
    required this.onTap,
    this.size = 120,
    this.baseColor = Colors.black87,
  }) : super(key: key);

  @override
  State<SimpleSunkenButton> createState() => _SimpleSunkenButtonState();
}

class _SimpleSunkenButtonState extends State<SimpleSunkenButton> {
  @override
  Widget build(BuildContext context) {
    // Determine the accent color based on state
    final accentColor = widget.isOn ? Colors.green : Colors.red;

    // Reverse shadows/gradients if the base color is light
    final isLightTheme = widget.baseColor.computeLuminance() > 0.5;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.baseColor,
          // 1. The outer soft glow (like your image)
          boxShadow: [
            BoxShadow(
              color: widget.isOn
                  ? Colors.green.withOpacity(0.8)
                  : Colors.red.withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.size * 0.08), // Creates the sunken rim
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isOn ? Colors.green : Colors.red,
                width: 3,
              ),
              shape: BoxShape.circle,
              // 2. The inner sunken effect (simulated with a sharp gradient)
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.4, 0.6, 0.9],
                colors: isLightTheme
                    ? [
                        Colors.black12, // Dark inner shadow
                        widget.baseColor,
                        widget.baseColor,
                        Colors.white.withOpacity(0.7), // Light catch
                      ]
                    : [
                        Colors.black54, // Deep inner shadow
                        widget.baseColor,
                        widget.baseColor,
                        Colors.white12, // Light catch
                      ],
              ),
            ),
            // 3. The Power Icon and dotted rim
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simplified Dotted Rim
                _DottedRim(
                  size: widget.size * 0.4,
                  color: widget.isOn ? Colors.green : Colors.red,
                ),

                // Active Power Symbol
                Icon(
                  Icons.power_settings_new_rounded,
                  size: widget.size * 0.4,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simple helper widget to draw the dotted ring
class _DottedRim extends StatelessWidget {
  final double size;
  final Color color;
  const _DottedRim({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2.5,
          style: BorderStyle.solid,
        ),
      ),
      // To simulate "dots", we can just use a simple thin border.
      // A complex dotted line requires custom paint which breaks the "simplicity" rule.
    );
  }
}
