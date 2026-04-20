import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/green_house/bottomnavGHS/bottomnavGHS.dart';
import 'package:testappbita/Views/green_house/humidity_setpoint/humidity_setpoint.dart';
import 'package:testappbita/Views/green_house/temp&humidity/temp_humidity.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class GreenHouse extends StatefulWidget {
  const GreenHouse({super.key});

  @override
  State<GreenHouse> createState() => _GreenHouseState();
}

class _GreenHouseState extends State<GreenHouse> {
  late String deviceName;
  late String deviceid;
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
  }

  @override
  void dispose() {
    _mqttController.updatetopicSSIDvalue("");
    _mqttController.timeAm2.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeColor().actual,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image.asset(
                  "assets/images/alert_master1.png",
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    deviceName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15,),
                Center(
                  child: TempHumidity(
                    deviceId: deviceid,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: HumiditySetpoint(
                    deviceid: deviceid,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  15.0),
                  child: Container(
                    height: baseSize * 0.08,
                    width: shortestSide * 0.9,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ThemeColor().mode2Sec
                          : ThemeColor().mode1Sec,
                      border: Border.all(
                        color: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(shortestSide * 0.04),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "pump".tr,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Obx(
                          () => Text(
                            _mqttController.deviceConnections[deviceid] ?? false
                                ? _mqttController.ghspump.value == "1"
                                    ? 'on'.tr
                                    : 'off'.tr
                                : '--',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Bottomnavghs()),
    );
  }
}
