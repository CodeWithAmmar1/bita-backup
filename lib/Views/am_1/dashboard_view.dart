import 'dart:async';
import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/am_1/custom_widget/pressure/pressure_container.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/settingAm1.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/userSettingAm1.dart';
import 'package:testappbita/Views/am_1/custom_widget/switch_page/switch_page.dart';
import 'package:testappbita/Views/am_1/custom_widget/temperature/temperature_container.dart';
import 'package:testappbita/Views/aqua%20master/main_screen/mainpage.dart';
import 'package:testappbita/Views/notification/notificaion_am1.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/am1_notificatio_controller/am1_notificatio_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

class Dashboardam1 extends StatefulWidget {
  final bool isFromDevicePage;
  const Dashboardam1({super.key, required this.isFromDevicePage});
  @override
  State<Dashboardam1> createState() => _DashboardState();
}

late String deviceName;
late String deviceid;
late String devicetype1;
late String devicetype2;

class _DashboardState extends State<Dashboardam1> {
  final ThemeController themeController = Get.find<ThemeController>();
  final MqttController _mqttController = Get.find<MqttController>();
  final NotificationControlleraM1 _notificationController =
      Get.put(NotificationControlleraM1());

  @override
  void initState() {
    super.initState();
    deviceName = Get.arguments?["name"] ?? "Unknown Device";
    deviceid = Get.arguments?["id"] ?? "Unknown id";
    _mqttController.timeAm2.value = true;
    devicetype1 = Get.arguments?["type"] ?? "Unknown type1";
    devicetype2 = Get.arguments?["type2"] ?? "Unknown type2";
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
                          IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Enter Password'.tr,
                                content: PasswordDialog1(
                                  deviceId: deviceid,
                                  isFromDevicePage: widget.isFromDevicePage,
                                ),
                              );
                            },
                            icon: Icon(Icons.settings, color: Colors.black),
                          ),
                          Obx(() {
                            return badges.Badge(
                              position:
                                  badges.BadgePosition.topEnd(top: -5, end: -5),
                              showBadge: true,
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              badgeContent: Text(
                                '${_notificationController.deviceNotificationMapAm1[deviceid]?.length ?? 0}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              child: CustomIconButton(
                                nextcolor: Colors.black,
                                backgroundcolor1: Colors.grey.withOpacity(0.2),
                                color: Colors.black,
                                icon: Icons.notifications,
                                onPressed: () {
                                  Get.to(() => NotificationPageAM1(
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
                                          ? _mqttController
                                                  .isModeSwitchAm1.value
                                              ? devicetype1
                                              : devicetype2
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
                                    _mqttController
                                                .deviceConnections[deviceid] ??
                                            false
                                        ? _mqttController.comprsw.value == 0
                                            ? 'off'.tr
                                            : _mqttController.comprsw.value == 1
                                                ? 'on'.tr
                                                : _mqttController
                                                            .comprsw.value ==
                                                        4
                                                    ? 'Restarting'.tr
                                                    : _mqttController.comprsw
                                                                .value ==
                                                            2
                                                        ? 'autoStopped'.tr
                                                        : _mqttController
                                                                    .comprsw
                                                                    .value ==
                                                                5
                                                            ? 'Return (TS)-High'
                                                                .tr
                                                            : _mqttController
                                                                        .comprsw
                                                                        .value ==
                                                                    6
                                                                ? 'Suction (TS)-Low'
                                                                    .tr
                                                                : _mqttController
                                                                            .comprsw
                                                                            .value ==
                                                                        7
                                                                    ? 'Discharge (TS)-High'
                                                                        .tr
                                                                    : _mqttController.comprsw.value ==
                                                                            8
                                                                        ? 'Suction (PS)-Low'
                                                                            .tr
                                                                        : _mqttController.comprsw.value ==
                                                                                9
                                                                            ? 'Discharge (PS)-High'.tr
                                                                            : _mqttController.comprsw.value == 12
                                                                                ? 'Suction (SW)-Low'.tr
                                                                                : _mqttController.comprsw.value == 13
                                                                                    ? 'Discharge (SW)-High'.tr
                                                                                    : _mqttController.comprsw.value == 14
                                                                                        ? 'Oil (SW)-Low'.tr
                                                                                        : _mqttController.comprsw.value == 15
                                                                                            ? 'Comp. Fail to Run'.tr
                                                                                            : _mqttController.comprsw.value == 16
                                                                                                ? 'Temp Sensor Error'.tr
                                                                                                : _mqttController.comprsw.value == 17
                                                                                                    ? 'MC Stuck'.tr
                                                                                                    : 'tripped'.tr
                                        : "--",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _mqttController.comprsw.value ==
                                                    1 ||
                                                _mqttController.comprsw.value ==
                                                    2 ||
                                                _mqttController.comprsw.value ==
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
                    TemperatureContainerAm1(
                      deviceId: deviceid,
                    ),
                    const SizedBox(height: 8),
                    PressureContainerAm1(
                      deviceId: deviceid,
                    ),
                    Obx(() {
                      if ((_mqttController.showOilPressure.value ||
                          _mqttController.showDischargePressure.value ||
                          _mqttController.showSuctionPressure.value)) {
                        return const SizedBox(height: 8);
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    SwitchPageAm1(
                      deviceId: deviceid,
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (_mqttController.powerSwitchen.value &&
                          _mqttController.isModeSwitchAm1.value) {
                        return MainRestartToggle(
                          LeftText: 'Stop'.tr,
                          rightText: 'Start'.tr,
                          title: 'system'.tr,
                          value: _mqttController.systemSwitchAm1.value,
                          onTap: () async {
                            _mqttController.systemSwitchAm1Loading.value = true;
                            final newValue =
                                !_mqttController.systemSwitchAm1.value;
                            await _mqttController.switchAm1(newValue);
                            _mqttController.systemSwitchAm1Loading.value =
                                false;
                            return newValue;
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    const SizedBox(height: 10),
                    ResetToggle(
                        resetload: _mqttController.am1Resetload,
                        title: 'Reset'.tr,
                        onTap: () async {
                          _mqttController.am1Resetload.value = true;
                          _mqttController.am1ResetValues.value = 1;
                          _mqttController.buildJsonPayloadAm1Sensor();
                          publishTimer?.cancel();
                          publishTimer = Timer(Duration(seconds: 5), () {
                            _mqttController.am1Resetload.value = false;
                            _mqttController.isUserInteracting.value = false;
                          });
                          log("DM Reset Pressed${_mqttController.am1ResetValues.value}");
                          return true;
                        })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PasswordDialog1 extends StatefulWidget {
  final bool isFromDevicePage;
  final String deviceId;
  const PasswordDialog1(
      {super.key, required this.deviceId, required this.isFromDevicePage});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordDialog1State createState() => _PasswordDialog1State();
}

final MqttController _mqttController = Get.find<MqttController>();

class _PasswordDialog1State extends State<PasswordDialog1> {
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool _obscureText = true;

  void _checkPassword() {
    if (_passwordController.text == '9753') {
      Get.back();
      Get.to(() => SettingAm1(
            isFromDevicePage: widget.isFromDevicePage,
          ));
    } else if (_passwordController.text == '1234' &&
        _mqttController.isModeSwitchAm1.value) {
      Get.back();
      Get.to(() => Usersettingam1());
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

class MainRestartToggle extends StatelessWidget {
  final bool value;
  final Future<bool> Function()? onTap;
  final String title;
  final String rightText;
  final String LeftText;

  const MainRestartToggle({
    super.key,
    required this.value,
    required this.onTap,
    required this.title,
    required this.rightText,
    required this.LeftText,
  });

  @override
  Widget build(BuildContext context) {
    final boxWidth = Get.width * 0.97;
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.01),
      child: Center(
        child: Container(
          width: boxWidth,
          padding: EdgeInsets.all(Get.width * 0.03),
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.02,
                  horizontal: Get.width * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LeftText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    LoadSwitch(
                      height: Get.height * 0.038,
                      width: Get.height * 0.08,
                      value: value,
                      future: onTap,
                      onChange: (_) {},
                      onTap: (val) {
                        // log("Tapped while value is $val");
                      },
                      animationDuration: const Duration(milliseconds: 300),
                      curveIn: Curves.easeInBack,
                      curveOut: Curves.easeOutBack,
                      style: SpinStyle.material,
                      switchDecoration: (value, loading) => BoxDecoration(
                        color: value
                            ? ThemeColor().actual.withValues(alpha: 0.2)
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: value
                                ? ThemeColor().actual.withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      spinColor: (value) => value
                          ? ThemeColor().actual
                          : const Color.fromARGB(255, 255, 77, 77),
                      spinStrokeWidth: 3,
                      thumbDecoration: (value, loading) => BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: value
                                ? ThemeColor().actual.withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      rightText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetToggle extends StatefulWidget {
  final Future<bool> Function()? onTap;
  final String title;
  final RxBool resetload;

  const ResetToggle({
    super.key,
    required this.onTap,
    required this.title,
    required this.resetload,
  });

  @override
  State<ResetToggle> createState() => _ResetToggleState();
}

class _ResetToggleState extends State<ResetToggle> {
  Timer? publishTimer;

  @override
  Widget build(BuildContext context) {
    final boxWidth = Get.width * 0.97;
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.01),
      child: Center(
        child: Container(
          width: boxWidth,
          padding: EdgeInsets.all(Get.width * 0.02),
          decoration: BoxDecoration(
            color:
                Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
            borderRadius: BorderRadius.circular(Get.width * 0.03),
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.03,
                  horizontal: Get.width * 0.03,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(Get.width * 0.02),
                  color:
                      Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
                ),
                child: Obx(
                  () => GestureDetector(
                    onTap: widget.onTap,
                    child: widget.resetload.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF24C48E),
                            ),
                          )
                        : const Icon(Icons.restart_alt_outlined,
                            size:
                                24, // Adjust the size as needed to match your layout
                            color: Color(
                                0xFF24C48E) // Optional: Add a color for your icon
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
