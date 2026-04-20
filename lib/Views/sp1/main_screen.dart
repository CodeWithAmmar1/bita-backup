import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/sp1/sp_notification_page/sp_notification.dart';
import 'package:testappbita/Views/sp1/widget/setting_page_sp.dart';
import 'package:testappbita/Views/sp1/widget/temperature_container_sp.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/sp_notification_Controller/sp_notification_Controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

late String deviceName;
late String deviceid;
late AnimationController _blinkController;
late Animation<double> _blinkAnimation;
Timer? publishTimer;

final SpNotificationController _notificationController =
    Get.put(SpNotificationController());
final MqttController _mqttController = Get.find<MqttController>();

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
    _mqttController.timeAm2.value = true;
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _blinkAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_blinkController);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _mqttController.updatetopicSSIDvalue("");
    _mqttController.timeAm2.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Obx(
              () => AppBar(
                actions: [
                  _mqttController.deviceConnections[deviceid] ?? false
                   ? CustomIconButton(
                                    nextcolor: Colors.blue.shade800,
                                    backgroundcolor1:
                                        Colors.grey.withOpacity(0.2),
                                    color: Colors.red,
                                    icon: Icons.cell_tower,
                                    onPressed: () {},
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomIconButton(
                                        nextcolor: Colors.black,
                                        backgroundcolor1:
                                            Colors.yellow.withOpacity(0.7),
                                        color: Colors.black,
                                        icon: Icons.cell_tower,
                                        onPressed: () {},
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Icon(Icons.cancel,
                                            size: 16, color: Colors.red),
                                      ),
                                    ],
                                  ),
                  Obx(() {
                    return badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -5, end: -5),
                      showBadge: true,
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.red,
                      ),
                      badgeContent: Text(
                        '${_notificationController.deviceNotificationMapSp1[deviceid]?.length ?? 0}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      child: CustomIconButton(
                        nextcolor: Colors.black,
                        backgroundcolor1: Colors.grey.withOpacity(0.2),
                        color: Colors.black,
                        icon: Icons.notifications,
                        onPressed: () {
                          Get.to(() => SpNotification(
                                deviceid: deviceid,
                              ));
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _mqttController.deviceConnections[deviceid] ?? false
                              ? _mqttController.systemSwitchsp.value
                                  ? 'ON'.tr
                                  : 'OFF'.tr
                              : "--",
                          style: TextStyle(
                            fontSize: 18,
                            color: Get.isDarkMode ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: _mqttController.systemSwitchsp.value,
                            onChanged: (val) {
                              _mqttController.isUserInteracting.value = true;
                              _mqttController.updatePowerSp(val);
                              publishTimer?.cancel();
                              publishTimer = Timer(Duration(seconds: 1), () {
                                publishTimer = Timer(Duration(seconds: 1), () {
                                  _mqttController.isUserInteracting.value =
                                      false;
                                });
                              });
                            },
                            activeColor: Colors.green,
                            activeTrackColor:
                                Get.isDarkMode ? Colors.black : Colors.white,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor:
                                Get.isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
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
                          color: isDark ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ),
          ),
          backgroundColor:
              Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          //
                          Padding(
                            padding: EdgeInsets.all(Get.width * 0.02),
                            child: Container(
                              width: Get.width * 0.95,
                              padding: EdgeInsets.all(Get.width * 0.03),
                              decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? ThemeColor().mode2Sec
                                    : ThemeColor().mode1Sec,
                                borderRadius:
                                    BorderRadius.circular(Get.width * 0.03),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Get.height * 0.005),
                                    child: Text(
                                      'Temperature Monitoring System'.tr,
                                      style: TextStyle(
                                        fontSize: Get.width * 0.055,
                                        fontWeight: FontWeight.bold,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //

                          Center(
                            child: Container(
                              width: constraints.maxWidth * 0.95,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isDark
                                    ? ThemeColor().mode2
                                    : ThemeColor().mode1,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${'Temperature Status'.tr} :",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Obx(() {
                                    bool connected = _mqttController
                                            .deviceConnections[deviceid] ??
                                        false;

                                    int status =
                                        _mqttController.sp1comprsw.value;

                                    String text = connected
                                        ? status == 0
                                            ? 'NORMAL'.tr
                                            : status == 1
                                                ? 'HIGH'.tr
                                                : status == 2
                                                    ? 'SYSTEM OFF'.tr
                                                    : 'tripped'.tr
                                        : "--";
                                    if (!connected) {
                                      return Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      );
                                    }
                                    // HIGH → BLINK
                                    if (status == 1) {
                                      return blinkText(text, _blinkAnimation);
                                    }

                                    return Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: status == 0
                                            ? Colors.green
                                            : Colors.redAccent,
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TemperatureContainerSp(
                        deviceId: deviceid,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: SettingPageSp(
                          deviceid: deviceid,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
    // );
  }
}

Widget blinkText(String text, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent,
      ),
    ),
  );
}
