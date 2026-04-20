import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/aqua%20master/main_screen/mainpage.dart';
import 'package:testappbita/Views/csm/csm_noti_screen/csm_noti_screen.dart';
import 'package:testappbita/Views/csm/widget/csm_setpoint.dart';
import 'package:testappbita/Views/csm/widget/temperature_containercsm.dart';
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
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    Timer? publishTimer;
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
                            child:
                                Icon(Icons.cancel, size: 16, color: Colors.red),
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
                        Get.to(() => CsmNotiScreen(
                              deviceid: deviceid,
                            ));
                      },
                    ),
                  );
                }),
                SizedBox(width: 10),
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
        ),
        bottomNavigationBar: Container(
          height: baseSize * 0.111,
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_mqttController.csmSw.value == true) {
                      _mqttController.isUserInteracting.value = true;
                      _mqttController.csmSw.value = false;
                      _mqttController.updatePowerCsm(false);
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 1), () {
                        _mqttController.isUserInteracting.value = false;
                      });
                    } else {
                      _mqttController.csmSw.value = true;
                      _mqttController.isUserInteracting.value = true;
                      _mqttController.updatePowerCsm(true);
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 1), () {
                        _mqttController.isUserInteracting.value = false;
                      });
                    }
                  },
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.power_settings_new,
                      _mqttController.csmSw.value == true
                          ? Color(0xFF24C48E)
                          : Colors.red,
                      Colors.grey.shade200,
                      _mqttController.csmSw.value == true
                          ? 'Power On'.tr
                          : 'Power Off'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      _mqttController.csmResetload.value = true;
                      _mqttController.csmResetValues.value = 1;
                      _mqttController.buildJsonPayloadCsm();
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 5), () {
                        _mqttController.csmResetload.value = false;
                        _mqttController.isUserInteracting.value = false;
                      });
                    },
                    child: buildIconContainer(
                      context,
                      _mqttController.csmResetload.value
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF24C48E),
                              ),
                            )
                          : Icons.restart_alt_outlined,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                      'Reset'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CsmSetpoint(
                          deviceid: deviceid,
                        ));
                  },
                  child: buildIconContainer(
                    context,
                    Icons.settings,
                    Color(0xFF24C48E),
                    Colors.grey.shade200,
                    'Setpoint'.tr,
                    Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }
}
