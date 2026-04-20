import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/csm/widget/csm_setpoint.dart';
import 'package:testappbita/Views/csm/widget/temperature_containercsm.dart';
import 'package:testappbita/Views/sp1/sp_notification_page/sp_notification.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/csm_notification_controller/notification_controllercsm.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CsmMainscreen extends StatefulWidget {
  const CsmMainscreen({super.key});

  @override
  CsmMainscreenState createState() => CsmMainscreenState();
}

late String deviceName;
late String deviceid;
Timer? publishTimer;

final NotificationControllercsm _notificationController =
    Get.put(NotificationControllercsm());
final MqttController _mqttController = Get.find<MqttController>();

class CsmMainscreenState extends State<CsmMainscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
    _mqttController.timeAm2.value = true;
  }

  @override
  void dispose() {
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
                          backgroundcolor1: Colors.grey.withOpacity(0.2),
                          color: Colors.red,
                          icon: Icons.cell_tower,
                          onPressed: () {},
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomIconButton(
                              nextcolor: Colors.black,
                              backgroundcolor1: Colors.yellow.withOpacity(0.7),
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
                        '${_notificationController.deviceNotificationMapCsm[deviceid]?.length ?? 0}',
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
                  CustomIconButton(
                    nextcolor: Colors.black,
                    backgroundcolor1: Colors.grey.withOpacity(0.2),
                    color: Colors.black,
                    icon: Icons.settings,
                    onPressed: () {
                      Get.to(() => CsmSetpoint(
                            deviceid: deviceid,
                          ));
                    },
                  ),
                  Obx(() {
                    return Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _mqttController.deviceConnections[deviceid] ?? false
                              ? _mqttController.csmSw.value
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
                            value: _mqttController.csmSw.value,
                            onChanged: (val) {
                              _mqttController.isUserInteracting.value = true;
                              _mqttController.updatePowerCsm(val);
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
                          Padding(
                            padding: EdgeInsets.all(Get.width * 0.01),
                            child: Container(
                              width: double.infinity,
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
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: Text(
                                      'Cold Storage Monitoring System'.tr,
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
                        ],
                      ),
                      SizedBox(height: Get.height * 0.02),
                      TemperatureContainercsm(
                        value: _mqttController.tempcsm,
                        heading: "Current Temperature".tr,
                        unit: "°C",
                        icon: Icons.thermostat,
                        deviceId: deviceid,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      HumidityContainercsm(
                        value: _mqttController.humcsm,
                        heading: "Current Humidity".tr,
                        unit: "%",
                        icon: Icons.opacity,
                        deviceId: deviceid,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      HumidityContainercsm(
                        value: _mqttController.hrscsm,
                        heading: "Running Hours".tr,
                        unit: "Hr",
                        icon: Icons.access_time,
                        deviceId: deviceid,
                      ),
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
