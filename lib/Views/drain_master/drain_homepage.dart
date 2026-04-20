import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/drain_master/bottomNav/bottomNAv_DM.dart';
import 'package:testappbita/Views/drain_master/notification/drain_noti.dart';
import 'package:testappbita/Views/drain_master/setting/drainDelaySetting.dart';
import 'package:testappbita/Views/drain_master/water_level/drainWater_level.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/drain_master_notification/drain_master_notification.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:badges/badges.dart' as badges;

class DrainHomepage extends StatefulWidget {
  final String title;
  final IconData icon;
  const DrainHomepage({super.key, required this.icon, required this.title});

  @override
  State<DrainHomepage> createState() => _DrainHomepageState();
}

late String deviceName;
late String deviceid;
class _DrainHomepageState extends State<DrainHomepage> {
  final MqttController mqttController = Get.find<MqttController>();
  final DrainMasterNotification _notificationController =
      Get.find<DrainMasterNotification>();
  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
    mqttController.timeAm2.value = true;
    mqttController.lastNotifiedValuePerDeviceDm1[deviceid] = {};
    mqttController.level.value = 0;
  }

  @override
  void dispose() {
    super.dispose();
    mqttController.updatetopicSSIDvalue("");
    mqttController.timeAm2.value = false;
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
          backgroundColor:
              Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: const Color(0xFF24C48E),
            actions: [
              IconButton(
                icon: Icon(Icons.settings,
                    color: Get.isDarkMode ? Colors.black : Colors.white),
                onPressed: () {
                  Get.to(() => Draindelaysetting());
                },
              ),
              Obx(() {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -5, end: -5),
                  showBadge: true,
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  badgeContent: Text(
                    '${_notificationController.deviceNotificationMapDm[deviceid]?.length ?? 0}',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: CustomIconButton(
                    nextcolor: Colors.black,
                    backgroundcolor1: Colors.grey.withOpacity(0.2),
                    color: Colors.black,
                    icon: Icons.notifications,
                    onPressed: () {
                      Get.to(() => DrainNoti(
                            deviceid: deviceid,
                          ));
                    },
                  ),
                );
              }),
              const SizedBox(width: 12),
            ],
            title: Row(
              children: [
                Image.asset(
                  "assets/images/control_master.png",
                  width: 45,
                  height: 45,
                ),
                const SizedBox(width: 10),
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
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
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
                        borderRadius:
                            BorderRadius.circular(shortestSide * 0.04),
                      ),
                      child: Center(
                        child: Text(
                          widget.title.tr,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DrainwaterLevel(
                    title: widget.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
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
                        borderRadius:
                            BorderRadius.circular(shortestSide * 0.04),
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
                              mqttController.deviceConnections[deviceid] ??
                                      false
                                  ? mqttController.dmpump.value == "1"
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
          ),
          bottomNavigationBar: BottomnavDm()),
    );
  }
}
