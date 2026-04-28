import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/rms/config_page/config_page.dart';
import 'package:testappbita/Views/rms/config_page_slider/config_page_slider.dart';
import 'package:testappbita/Views/rms/damper/damperPage.dart';
import 'package:testappbita/Views/rms/widgets/ac_switch.dart';
import 'package:testappbita/Views/rms/widgets/curtain.dart';
import 'package:testappbita/Views/rms/widgets/damper.dart';
import 'package:testappbita/Views/rms/widgets/room_fan.dart';
import 'package:testappbita/Views/rms/widgets/room_light.dart';
import 'package:testappbita/Views/rms/widgets/shutter.dart';
import 'package:testappbita/Views/rms/widgets/smart_tv.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

// ignore: must_be_immutable
class RmsMainScreen extends StatefulWidget {
  const RmsMainScreen({super.key});

  @override
  State<RmsMainScreen> createState() => _RmsMainScreenState();
}

final MqttController _mqttcontroller = Get.find<MqttController>();

class _RmsMainScreenState extends State<RmsMainScreen> {
  final themeController = Get.find<ThemeController>();
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
            const Expanded(
              child: Text(
                "RMS-AAA010",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings, color: Colors.white),
        //     onPressed: () {
        //       // Handle settings button press
        //     },
        //   ),
        //   const SizedBox(width: 12),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         CarbonMono(
              //           value: _mqttcontroller.carbonMono,
              //         ),
              //         Column(
              //           children: [
              //             Text("CO",
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 14,
              //                   color: Get.isDarkMode
              //                       ? Colors.white
              //                       : Colors.black,
              //                 )),
              //             SizedBox(
              //               height: 20,
              //             )
              //           ],
              //         )
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Icon(
              //           Icons.cloud_queue,
              //           size: 40,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text("24°C",
              //             style: TextStyle(
              //               fontSize: 30,
              //               color: Get.isDarkMode ? Colors.white : Colors.black,
              //             )),
              //       ],
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                "DEVICES :",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ConfigPageSlider(
                            currentValue: _mqttcontroller.light1value,
                            power: _mqttcontroller.roomlight1,
                            heading: "INTENSITY",
                            title: "LIGHT 1",
                            image: "assets/images/bulb.png",
                          ));
                    },
                    child: Roomlight(
                      brightness: _mqttcontroller.light1value,
                      isActive: _mqttcontroller.roomlight1,
                      title: "LIGHT 1",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ConfigPageSlider(
                            currentValue: _mqttcontroller.light2value,
                            power: _mqttcontroller.roomlight2,
                            heading: "INTENSITY",
                            title: "LIGHT 2",
                            image: "assets/images/bulb.png",
                          ));
                    },
                    child: Roomlight(
                      brightness: _mqttcontroller.light2value,
                      isActive: _mqttcontroller.roomlight2,
                      title: "LIGHT 2",
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ConfigPage(
                            title: "AC SWITCH",
                            power: _mqttcontroller.acswitch,
                          ));
                    },
                    child: AcSwitch(
                      isActive: _mqttcontroller.acswitch,
                      brightness: _mqttcontroller.acTemp,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ConfigPageSlider(
                          currentValue: _mqttcontroller.curtainValue,
                          power: _mqttcontroller.curtainSw,
                          heading: "RANGE",
                          image: "assets/images/curtain.png",
                          title: "CURTAIN"));
                    },
                    child: Curtain(
                      isActive: _mqttcontroller.curtainSw,
                      curtainValue: _mqttcontroller.curtainValue,
                    ),
                  ),
                ],
              ),
              // in kuwait
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.to(() => ConfigPageSlider(
                            currentValue: _mqttcontroller.shutterValue,
                            power: _mqttcontroller.shutterSw,
                            heading: "RANGE",
                            image: "assets/images/shutter.png",
                            title: "SHUTTER"));
                      },
                      child: Shutter(
                        isActive: _mqttcontroller.shutterSw,
                        brightness: _mqttcontroller.shutterValue,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DamperPage(
                            deviceId: "RMS-AAA001",
                          ));
                    },
                    child: Damper(
                      cfm: _mqttcontroller.currentValue,
                      isActive: _mqttcontroller.damperSw,
                      season: _mqttcontroller.isSummer,
                      temp: _mqttcontroller.acTemp,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ConfigPage(
                            title: "SMART TV",
                            power: _mqttcontroller.smarttv,
                          ));
                    },
                    child: SmartTv(
                      isActive: _mqttcontroller.smarttv,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ConfigPage(
                            title: "ROOM FAN",
                            power: _mqttcontroller.roomfan,
                          ));
                    },
                    child: RoomFan(
                      intensity: _mqttcontroller.roomfanIntensity,
                      isActive: _mqttcontroller.roomfan,
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Get.to(() => ConfigPage(
              //               title: "DOOR LOCK",
              //               power: _mqttcontroller.doorlock,
              //             ));
              //       },
              //       child: Door(
              //         isActive: _mqttcontroller.doorlock,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Get.to(() => ConfigPage(
              //               title: "MOTION DETECTOR",
              //               power: _mqttcontroller.motionsensor,
              //             ));
              //       },
              //       child: Motion(
              //         isActive: _mqttcontroller.motionsensor,
              //       ),
              //     )
              //   ],
              // ),

              // Row(
              //   children: [
              //     GestureDetector(
              //         onTap: () {
              //           Get.to(() => ConfigPage(
              //                 title: "VOICE CONTROL",
              //                 power: _mqttcontroller.voicecontrol,
              //               ));
              //         },
              //         child: VoiceControl(
              //           isActive: _mqttcontroller.voicecontrol,
              //         )),
              //     SizedBox(
              //       width: 10,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
