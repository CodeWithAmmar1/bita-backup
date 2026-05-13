import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

// ignore: must_be_immutable
class MinMaxExvChm extends StatelessWidget {
  final bool permission;
  final RxInt minn;
  final RxInt maxx;

  final MqttController _mqttController = Get.find<MqttController>();

  MinMaxExvChm(
      {super.key,
      required this.minn,
      required this.maxx,
      required this.permission});
  Timer? publishTimer;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'EXV Min Max Settings',
            style: TextStyle(
                fontSize: Get.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: baseSize * 0.197,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                            ),
                            child: Text(
                              "Min: ${minn.value.toInt()}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Get.isDarkMode
                                  ? ThemeColor().mode2
                                  : ThemeColor().mode1,
                            ),
                            child: Text(
                              "Max: ${maxx.value.toInt()}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          rangeThumbShape: const RoundRangeSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          rangeTrackShape:
                              const RoundedRectRangeSliderTrackShape(),
                          valueIndicatorColor:
                              ThemeColor().actual, // background color
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white, // text color
                            fontWeight: FontWeight.bold,
                          ),
                          showValueIndicator: ShowValueIndicator.always,
                        ),
                        child: RangeSlider(
                          activeColor: ThemeColor().actual,
                          values: RangeValues(
                            minn.value.toDouble(),
                            maxx.value.toDouble(),
                          ),
                          min: 0,
                          max: 100,
                          divisions: 90,
                          labels: RangeLabels(
                            minn.value.toString(),
                            maxx.value.toString(),
                          ),
                          onChanged: (RangeValues values) {
                              _mqttController.isUserInteracting.value = true;
                            if (permission) {
                              _mqttController.updateRangeA(values);
                            } else {
                              _mqttController.updateRangeB(values);
                            }
                          },
                          onChangeEnd: (RangeValues values) {
                            publishTimer?.cancel();
                            publishTimer = Timer(Duration(seconds: 1), () {
                              if (permission) {
                                _mqttController.buildJsonPayloadCiruitA();
                              } else {
                                _mqttController.buildJsonPayloadCiruitB();
                              }
                              publishTimer = Timer(Duration(seconds: 1), () {
                                _mqttController.isUserInteracting.value = false;
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
