import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SwitchCardSettingNew extends StatelessWidget {
  final int index;
  final String deviceid;
  final String? heading;
  final String? title;
  final RxString temp;
  final double value;

  SwitchCardSettingNew({
    super.key,
    required this.index,
    this.heading,
    this.title,
    required this.value,
    required this.temp,
    required this.deviceid,
  });
  final MqttController mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;

    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: baseSize * 0.08,
              width: shortestSide * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(shortestSide * 0.04),
                color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (heading != null) ...[
                    Text(
                      heading!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                  if (title != null) ...[
                    Stack(alignment: Alignment.center, children: [
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ])
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
