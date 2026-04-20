import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/userSettingAm1.dart';
import 'package:testappbita/Views/notification/notification_telecome.dart';
import 'package:testappbita/Views/telecome/status_widget_telecome/status_widget.dart';
import 'package:testappbita/Views/telecome/telecom_widgets/tempearture/telecom_temp_container.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/telecome_notification_controller/telecom_notification_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class TelecomDashboard extends StatefulWidget {
  const TelecomDashboard({super.key});
  @override
  State<TelecomDashboard> createState() => _DashboardState();
}

late String deviceName;
late String deviceid;

class _DashboardState extends State<TelecomDashboard> {
  final MqttController _mqttController = Get.find<MqttController>();
  final TelecomNotificationController _notificationControllerTel =
      Get.find<TelecomNotificationController>();

  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
    _mqttController.timeAm2.value = true;
  }

  @override
  void dispose() {
    super.dispose();
    _mqttController.updatetopicSSIDvalue("");
    _mqttController.timeAm2.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(
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
                                position: badges.BadgePosition.topEnd(
                                    top: -5, end: -5),
                                showBadge: true,
                                badgeStyle: badges.BadgeStyle(
                                  badgeColor: Colors.red,
                                ),
                                badgeContent: Text(
                                  '${_notificationControllerTel.deviceNotificationMapTel[deviceid]?.length ?? 0}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                child: CustomIconButton(
                                  nextcolor: Colors.black,
                                  backgroundcolor1:
                                      Colors.grey.withOpacity(0.2),
                                  color: Colors.black,
                                  icon: Icons.notifications,
                                  onPressed: () {
                                    Get.to(() => NotificationTelecome(
                                          deviceid: deviceid,
                                        ));
                                  },
                                ),
                              );
                            }),
                            const SizedBox(width: 12),
                          ],
                          backgroundColor: ThemeColor().actual,
                          automaticallyImplyLeading: false,
                          title: Row(
                            children: [
                              Image.asset(
                                "assets/images/telecome.png",
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
                      const SizedBox(height: 12),
                      Column(
                        children: [
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
                              child: Obx(
                                () => Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "${'compressor_status'.tr} :",
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
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          _mqttController.deviceConnections[
                                                      deviceid] ??
                                                  false
                                              ? _mqttController
                                                          .systemStatusTel.value ==
                                                      0
                                                  ? 'off'.tr
                                                  : _mqttController.systemStatusTel
                                                              .value ==
                                                          1
                                                      ? 'on'.tr
                                                      : _mqttController
                                                                  .systemStatusTel
                                                                  .value ==
                                                              2
                                                          ? 'autoStopped'.tr
                                                          : 'off'.tr
                                              : "--",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: _mqttController.systemStatusTel
                                                              .value ==
                                                          1 ||
                                                      _mqttController
                                                              .systemStatusTel
                                                              .value ==
                                                          2
                                                  ? Colors.green
                                                  : Colors.redAccent),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TelecomTempContainer(
                        deviceId: deviceid,
                      ),
                      const SizedBox(height: 8),
                      StatusWidget(
                        deviceId: deviceid,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(Get.width * 0.02),
                        child: Obx(
                          () => RestartToggle(
                            LeftText: 'Stop'.tr,
                            rightText: 'Start'.tr,
                            title: 'system'.tr,
                            value:
                                // _mqttController.systemStatusTel == 3
                                //     ? _mqttController.systemSwitchTel.value == false
                                //     :
                                _mqttController.systemSwitchTel.value,
                            onTap: () async {
                              // if (_mqttController.systemStatusTel == 3) {
                              //   return _mqttController.systemSwitchTel.value ==
                              //       0;
                              // }
                              _mqttController.systemSwitchTelLoading.value =
                                  true;
                              final newValue =
                                  !_mqttController.systemSwitchTel.value;
                              await _mqttController.switchTel(newValue);
                              _mqttController.systemSwitchTelLoading.value =
                                  false;
                              return newValue;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
