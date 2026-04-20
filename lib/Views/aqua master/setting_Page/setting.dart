import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:testappbita/Views/aqua%20master/toggleButton/toggle_button.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TemperatureDialog extends StatefulWidget {
  final RxInt switchStatus;
  final RxString temperature;
  final RxString setpoint;
  final String title;
  final Function onTapAdd;
  final Function onTapSub;
  final Function onslider;
  final Function onsliderEnd;
  final double maxTemp;
  const TemperatureDialog(
      {super.key,
      required this.temperature,
      required this.setpoint,
      required this.title,
      required this.onTapAdd,
      required this.onTapSub,
      required this.onslider,
      required this.onsliderEnd,
      required this.switchStatus,
      required this.maxTemp});

  @override
  TemperatureDialogState createState() => TemperatureDialogState();
}

double getResponsiveFontSize(double screenWidth, double baseSize) {
  return (screenWidth * baseSize).clamp(16.0, 40.0);
}

class TemperatureDialogState extends State<TemperatureDialog> {
  final MqttController mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor:
              Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("${widget.title} ${'settings'.tr}",
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                )),
            backgroundColor: ThemeColor().actual,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: baseSize * 0.10),
                Obx(
                  () => Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            size: baseSize * 0.35,
                            angleRange: 300,
                            startAngle: 120,
                            customWidths: CustomSliderWidths(
                              trackWidth: shortestSide * 0.008,
                              progressBarWidth: shortestSide * 0.008,
                              handlerSize: shortestSide * 0.025,
                            ),
                            customColors: CustomSliderColors(
                              trackColor: Colors.grey[500],
                              progressBarColors: [
                                Color(0xFF24C48E),
                                Color(0xFF24C456)
                              ],
                              dotColor: Color(0xFF24C48E),
                            ),
                          ),
                          min: 0,
                          max: widget.maxTemp,
                          initialValue: int.parse(widget.setpoint.value)
                              .toDouble()
                              .clamp(0, widget.maxTemp),
                          onChangeStart: (_) {
                            mqttController.isUserInteracting.value = true;
                          },
                          onChange: (value) {
                            mqttController.isUserInteracting.value = true;
                            widget.onslider(value);
                          },
                          onChangeEnd: (double value) {
                            widget.onsliderEnd();

                            mqttController.isUserInteracting.value = false;
                          },
                        ),
                        Container(
                          width: shortestSide * 0.6,
                          height: baseSize * 0.3,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ThemeColor().mode2Sec
                                : ThemeColor().mode1Sec,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Get.isDarkMode
                                    ? ThemeColor().actual.withValues(alpha: 0.8)
                                    : Colors.black26,
                                blurRadius: 20,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: baseSize * 0.035,
                              ),
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: mqttController.isConnected.value
                                    ? Color(0xFF24C48E)
                                    : Colors.red,
                              ),
                              SizedBox(
                                height: baseSize * 0.03,
                              ),
                              SizedBox(
                                height: baseSize * 0.12,
                                child: Text(
                                  "${widget.setpoint.value}°C",
                                  style: TextStyle(
                                    fontFamily: 'DS-Digital',
                                    fontSize: shortestSide * 0.2,
                                    fontWeight: FontWeight.bold,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                '${widget.title} ${'Temp.'.tr} ${widget.temperature.value}°C',
                                style: TextStyle(
                                  fontSize: shortestSide * 0.035,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.onTapSub();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        padding: EdgeInsets.symmetric(
                            horizontal: shortestSide * 0.12,
                            vertical: baseSize * 0.001),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: ThemeColor().actual,
                        size: (screenWidth * 0.06).clamp(20.0, 30.0),
                      ),
                    ),
                    Container(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      width: shortestSide * 0.28,
                      height: baseSize * 0.05,
                      child: Center(
                        child: Text(
                          'Set Point'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onTapAdd();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        padding: EdgeInsets.symmetric(
                            horizontal: shortestSide * 0.12,
                            vertical: baseSize * 0.001),
                      ),
                      child: Icon(
                        Icons.add,
                        color: ThemeColor().actual,
                        size: (screenWidth * 0.06).clamp(20.0, 30.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: baseSize * 0.05,
                ),
                ThreeModeToggle(
                  mode: widget.switchStatus,
                  label: 'Mode'.tr,
                  onChanged: (val) {
                    widget.switchStatus.value = val;
                    mqttController.buildJsonPayloadAQM();
                  },
                ),
              ],
            ),
          )),
    );
  }
}
