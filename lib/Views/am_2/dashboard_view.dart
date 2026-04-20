import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/am_2/custom_widget/amperes/ampere_container.dart';
import 'package:testappbita/Views/am_2/custom_widget/pressure/pressure_container.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/setting_screen.dart';
import 'package:testappbita/Views/am_2/custom_widget/setting_screen/userScreen.dart';
import 'package:testappbita/Views/am_2/custom_widget/switch_page/switch_page.dart';
import 'package:testappbita/Views/am_2/custom_widget/temperature/temperature_container.dart';
import 'package:testappbita/Views/notification/notification.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/am2_notification_controller/notification_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

class Dashboardam2 extends StatefulWidget {
  final bool isFromDevicePage;
  const Dashboardam2({super.key, required this.isFromDevicePage});
  @override
  State<Dashboardam2> createState() => _DashboardState();
}

late String deviceName;
late String deviceid;

class _DashboardState extends State<Dashboardam2> {
  final ThemeController themeController = Get.find<ThemeController>();
  final MqttController _mqttController = Get.find<MqttController>();
  final NotificationController _notificationController =
      Get.find<NotificationController>();

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
                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Enter Password'.tr,
                      content: PasswordDialog(
                        isFromDevicePage: widget.isFromDevicePage,
                      ),
                    );
                  },
                  icon: Icon(Icons.settings, color: Colors.black),
                ),
                Obx(() {
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -5, end: -5),
                    showBadge: true,
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Colors.red,
                    ),
                    badgeContent: Text(
                      '${_notificationController.deviceNotificationMap[deviceid]?.length ?? 0}',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: CustomIconButton(
                      nextcolor: Colors.black,
                      backgroundcolor1: Colors.grey.withOpacity(0.2),
                      color: Colors.black,
                      icon: Icons.notifications,
                      onPressed: () {
                        Get.to(() => NotificationPage(
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
                    "assets/images/alert_master2.png",
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
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        _mqttController.deviceConnections[
                                                    deviceid] ??
                                                false
                                            ? _mqttController.isModeSwitch.value
                                                ? "AM2-${"control_system".tr}"
                                                : "AM2-${"monitoring_system".tr}"
                                            : "--",
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
                                ),
                              )
                            ],
                          ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    Text(
                                      _mqttController.deviceConnections[
                                                  deviceid] ??
                                              false
                                          ? _mqttController.comp1status.value ==
                                                  0
                                              ? 'off'.tr
                                              : _mqttController
                                                          .comp1status.value ==
                                                      1
                                                  ? 'on'.tr
                                                  : _mqttController.comp1status
                                                              .value ==
                                                          4
                                                      ? 'restarting'.tr
                                                      : _mqttController
                                                                  .comp1status
                                                                  .value ==
                                                              2
                                                          ? 'auto_stopped'.tr
                                                          : _mqttController
                                                                      .comp1status
                                                                      .value ==
                                                                  5
                                                              ? 'return_ts_high'
                                                                  .tr
                                                              : _mqttController
                                                                          .comp1status
                                                                          .value ==
                                                                      6
                                                                  ? 'suction_ts_low'
                                                                      .tr
                                                                  : _mqttController
                                                                              .comp1status
                                                                              .value ==
                                                                          7
                                                                      ? 'discharge_ts_high'
                                                                          .tr
                                                                      : _mqttController.comp1status.value ==
                                                                              8
                                                                          ? 'suction_ps_low'
                                                                              .tr
                                                                          : _mqttController.comp1status.value == 9
                                                                              ? 'discharge_ps_high'.tr
                                                                              : _mqttController.comp1status.value == 10
                                                                                  ? 'oil_ps_low'.tr
                                                                                  : _mqttController.comp1status.value == 11
                                                                                      ? 'comp_current_high'.tr
                                                                                      : _mqttController.comp1status.value == 12
                                                                                          ? 'suction_sw_low'.tr
                                                                                          : _mqttController.comp1status.value == 13
                                                                                              ? 'discharge_sw_high'.tr
                                                                                              : _mqttController.comp1status.value == 14
                                                                                                  ? 'oil_sw_low'.tr
                                                                                                  : _mqttController.comp1status.value == 15
                                                                                                      ? 'comp_fail_to_run'.tr
                                                                                                      : _mqttController.comp1status.value == 16
                                                                                                          ? 'returnTsFail'.tr
                                                                                                          : _mqttController.comp1status.value == 17
                                                                                                              ? 'suctionTsFail'.tr
                                                                                                              : _mqttController.comp1status.value == 18
                                                                                                                  ? 'dischargeTsFail'.tr
                                                                                                                  : _mqttController.comp1status.value == 21
                                                                                                                      ? 'oilPsFail'.tr
                                                                                                                      : _mqttController.comp1status.value == 22
                                                                                                                          ? 'dischargePsFail'.tr
                                                                                                                          : _mqttController.comp1status.value == 23
                                                                                                                              ? 'suctionPsFail'.tr
                                                                                                                              : 'tripped'.tr
                                          : "--",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: _mqttController
                                                          .comp1status.value ==
                                                      1 ||
                                                  _mqttController
                                                          .comp1status.value ==
                                                      2 ||
                                                  _mqttController
                                                          .comp1status.value ==
                                                      4
                                              ? Colors.green
                                              : Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TemperatureContainer(
                        deviceId: deviceid,
                      ),
                      const SizedBox(height: 8),
                      PressureContainer(
                        deviceId: deviceid,
                      ),
                      Obx(() {
                        if (_mqttController.isAmpVisible.value) {
                          return const SizedBox(height: 8);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      AmpereContainer(
                        deviceId: deviceid,
                      ),
                      Obx(() {
                        if ((_mqttController.isSwitchBoxVisible.value ||
                            _mqttController.isSuctionSwitchVisible.value ||
                            _mqttController.isDischargeSwitchVisible.value)) {
                          return const SizedBox(height: 8);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      SwitchPage(
                        deviceId: deviceid,
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

class PasswordDialog extends StatefulWidget {
  final bool isFromDevicePage;
  const PasswordDialog({
    super.key,
    required this.isFromDevicePage,
  });
  @override
  // ignore: library_private_types_in_public_api
  _PasswordDialogState createState() => _PasswordDialogState();
}

final MqttController _mqttController = Get.find<MqttController>();

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool _obscureText = true;

  void _checkPassword() {
    if (_passwordController.text == '9753') {
      Get.back();
      Get.to(() => SettingPage(
            isFromDevicePage: widget.isFromDevicePage,
          ));
    } else if (_passwordController.text == '1234' &&
        _mqttController.isModeSwitch.value) {
      Get.back();
      Get.to(() => Userscreen());
    } else {
      setState(() {
        errorText = 'Incorrect password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: errorText.isNotEmpty ? errorText : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPassword,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit'.tr,
                  style: TextStyle(color: ThemeColor().actual),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
