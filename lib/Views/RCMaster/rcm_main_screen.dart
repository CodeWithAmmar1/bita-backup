import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/RCMaster/rc_notification_page/rcm_notification.dart';
import 'package:testappbita/Views/RCMaster/widget/TemperatureContainerRc.dart';
import 'package:testappbita/Views/RCMaster/widget/pressures/pressure_container_Rcm.dart';
import 'package:testappbita/Views/RCMaster/widget/setting_screen/setting_Rcm.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/rcm_notification_controller/rcm_notification_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class RcmMainScreen extends StatefulWidget {
  const RcmMainScreen({super.key});

  @override
  RcmMainScreenState createState() => RcmMainScreenState();
}

late String deviceName;
late String deviceid;
late AnimationController _blinkController;
late Animation<double> blinkAnimation;
Timer? publishTimer;

final RcmNotificationController _notificationController =
    Get.put(RcmNotificationController());
final MqttController _mqttController = Get.find<MqttController>();

class RcmMainScreenState extends State<RcmMainScreen>
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
    blinkAnimation =
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
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Enter Password'.tr,
                        content: PasswordDialog1(
                          deviceId: deviceid,
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
                        '${_notificationController.deviceNotificationMapRcm[deviceid]?.length ?? 0}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      child: CustomIconButton(
                        nextcolor: Colors.black,
                        backgroundcolor1: Colors.grey.withOpacity(0.2),
                        color: Colors.black,
                        icon: Icons.notifications,
                        onPressed: () {
                          Get.to(() => RcmNotification(
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
                              ? _mqttController.rcsystemSwitch.value
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
                            value: _mqttController.rcsystemSwitch.value,
                            onChanged: (val) {
                              _mqttController.isUserInteracting.value = true;
                              _mqttController.rcupdatePower(val);
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
                                      'RC MASTER'.tr,
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
                          Center(
                            child: Container(
                              width: constraints.maxWidth * 0.95,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
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
                                          ? _mqttController.rccompr.value == 0
                                              ? 'off'.tr
                                              : _mqttController.rccompr.value ==
                                                      1
                                                  ? 'on'.tr
                                                  : _mqttController
                                                              .rccompr.value ==
                                                          2
                                                      ? 'suction_ps_low'.tr
                                                      : _mqttController.rccompr
                                                                  .value ==
                                                              3
                                                          ? 'suction_ts_low'.tr
                                                          : "--"
                                          : "--",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _mqttController.rccompr.value == 1
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
                      const SizedBox(height: 20),
                      Temperaturecontainerrc(
                        deviceId: deviceid,
                      ),
                      const SizedBox(height: 8),
                      PressureContainerRcm(
                        deviceId: deviceid,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

class PasswordDialog1 extends StatefulWidget {
  final String deviceId;
  const PasswordDialog1({super.key, required this.deviceId});

  @override
  PasswordDialog1State createState() => PasswordDialog1State();
}

// final MqttController _mqttController = Get.find<MqttController>();

class PasswordDialog1State extends State<PasswordDialog1> {
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool _obscureText = true;

  void _checkPassword() {
    if (_passwordController.text == '1234') {
      Get.back();
      Get.to(() => SettingRcm());
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
