import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/aqua%20master/dailog/pass_dailog.dart';
import 'package:testappbita/Views/dx_400/IO/inputOutput.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_amperes/dx_ampere_container.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_pressure/dx_pressure_container.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_setting_screen/dx_setting_screen.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_setting_screen/dx_userScreen.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_switch_page/dx_switch_page.dart';
import 'package:testappbita/Views/dx_400/dx_custom_widget/dx_temperature/dx_temperature_container.dart';
import 'package:testappbita/Views/dx_400/navbar_widget/dx_modesheet.dart';
import 'package:testappbita/Views/dx_400/navbar_widget/dx_seasonsheet.dart';
import 'package:testappbita/Views/dx_400/notification_screen/dx_notification_page.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/dx_notification_controller/dx_notification_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

class DxDashboardView extends StatefulWidget {
  const DxDashboardView({super.key});
  @override
  State<DxDashboardView> createState() => _DxDashboardViewState();
}

late String deviceName;
late String deviceid;

class _DxDashboardViewState extends State<DxDashboardView> {
  final ThemeController themeController = Get.find<ThemeController>();
  final MqttController _mqttController = Get.find<MqttController>();
  final DxNotificationController _notificationController =
      Get.find<DxNotificationController>();
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

  void _showBottomSheet(String title) {
    if (title == 'Season'.tr) {
      Get.bottomSheet(
        DxSeasonsheet(),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      );
    } else if (title == 'Mode'.tr) {
      Get.bottomSheet(
        DxModesheet(),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;

    final isDark = Get.isDarkMode;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(
            () => AppBar(
              backgroundColor: ThemeColor().actual,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Row(
                children: [
                  Image.asset(
                    "assets/images/dx.png",
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
              actions: [
                // Connection Status
                (_mqttController.deviceConnections[deviceid] ?? false)
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

                // Settings button
                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Enter Password'.tr,
                      content: DxPasswordDialog(),
                    );
                  },
                  icon: const Icon(Icons.settings, color: Colors.black),
                ),

                // Notifications Badge
                badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -5, end: -5),
                  showBadge: true,
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  badgeContent: Text(
                    '${_notificationController.deviceNotificationMapDx[deviceid]?.length ?? 0}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: CustomIconButton(
                    nextcolor: Colors.black,
                    backgroundcolor1:  Colors.grey.withOpacity(0.2),
                    color: Colors.black,
                    icon: Icons.notifications,
                    onPressed: () {
                      Get.to(() => DxNotificationPage(deviceid: deviceid));
                    },
                  ),
                ),

                const SizedBox(width: 12),
              ],
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
                                          '${'compressor_status'.tr} :',
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
                                          ? _mqttController
                                                      .dxcomp1status.value ==
                                                  0
                                              ? 'off'.tr
                                              : _mqttController.dxcomp1status
                                                          .value ==
                                                      1
                                                  ? 'on'.tr
                                                  : _mqttController
                                                              .dxcomp1status
                                                              .value ==
                                                          4
                                                      ? 'restarting'.tr
                                                      : _mqttController
                                                                  .dxcomp1status
                                                                  .value ==
                                                              2
                                                          ? 'auto_stopped'.tr
                                                          : _mqttController
                                                                      .dxcomp1status
                                                                      .value ==
                                                                  5
                                                              ? 'return_ts_high'
                                                                  .tr
                                                              : _mqttController
                                                                          .dxcomp1status
                                                                          .value ==
                                                                      6
                                                                  ? 'suction_ts_low'
                                                                      .tr
                                                                  : _mqttController
                                                                              .dxcomp1status
                                                                              .value ==
                                                                          7
                                                                      ? 'discharge_ts_high'
                                                                          .tr
                                                                      : _mqttController.dxcomp1status.value ==
                                                                              8
                                                                          ? 'suction_ps_low'
                                                                              .tr
                                                                          : _mqttController.dxcomp1status.value == 9
                                                                              ? 'discharge_ps_high'.tr
                                                                              : _mqttController.dxcomp1status.value == 10
                                                                                  ? 'oil_ps_low'.tr
                                                                                  : _mqttController.dxcomp1status.value == 11
                                                                                      ? 'comp_current_high'.tr
                                                                                      : _mqttController.dxcomp1status.value == 12
                                                                                          ? 'suction_sw_low'.tr
                                                                                          : _mqttController.dxcomp1status.value == 13
                                                                                              ? 'discharge_sw_high'.tr
                                                                                              : _mqttController.dxcomp1status.value == 14
                                                                                                  ? 'oil_sw_low'.tr
                                                                                                  : _mqttController.dxcomp1status.value == 15
                                                                                                      ? 'comp_fail_to_run'.tr
                                                                                                      : _mqttController.dxcomp1status.value == 16
                                                                                                          ? 'condenser_overload'.tr
                                                                                                          : _mqttController.dxcomp1status.value == 17
                                                                                                              ? 'compressor_overload'.tr
                                                                                                              : _mqttController.dxcomp1status.value == 18
                                                                                                                  ? 'heater_fail_to_run'.tr
                                                                                                                  : _mqttController.dxcomp1status.value == 19
                                                                                                                      ? 'innerfan_fail_to_run'.tr
                                                                                                                      :
                                                                                                                      _mqttController.dxcomp1status.value == 20
                                                                                                                      ?  'system_delay'.tr
                                                                                                                      :  'tripped'.tr
                                          : "--",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _mqttController.dxcomp1status
                                                              .value ==
                                                          1 ||
                                                      _mqttController
                                                              .dxcomp1status
                                                              .value ==
                                                          2 ||
                                                      _mqttController
                                                              .dxcomp1status
                                                              .value ==
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
                      DxTemperatureContainer(
                        deviceId: deviceid,
                      ),
                      const SizedBox(height: 8),
                      DxPressureContainer(
                        deviceId: deviceid,
                      ),
                      Obx(() {
                        if (_mqttController.dxisAmpVisible.value) {
                          return const SizedBox(height: 8);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      DxAmpereContainer(
                        deviceId: deviceid,
                      ),
                      Obx(() {
                        if ((_mqttController.dxisSwitchBoxVisible.value ||
                            _mqttController.dxisSuctionSwitchVisible.value ||
                            _mqttController.dxisDischargeSwitchVisible.value)) {
                          return const SizedBox(height: 8);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      DxSwitchPage(
                        deviceId: deviceid,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        //bottom navigation bar
        bottomNavigationBar: 
       
        Container(
          height: baseSize * 0.111,
          color: Get.isDarkMode ? ThemeColor().mode2Sec : ThemeColor().mode1Sec,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    _showBottomSheet('Season'.tr);
                  },
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.dashboard,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                      _mqttController.isSummer.value
                          ? 'cooling'.tr
                          : 'heating'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Enter Password'.tr,
                      content: PasscodeDialog(
                        onPasscodeEntered: (passcode) {
                          if (passcode == '1234') {
                            Get.back();
                            _showBottomSheet('Mode'.tr);
                          } else {
                            Get.snackbar('error'.tr, 'wrong_password'.tr,
                                backgroundColor: Colors.red);
                          }
                        },
                      ),
                    );
                  },
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.settings_outlined,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                      _mqttController.modeDx.value ? 'auto'.tr : 'manual'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Obx(() => GestureDetector(
                      onTap: () {
                        log(_mqttController.modeDx.value.toString());
                        if (_mqttController.modeDx.value == false) {
                          Get.defaultDialog(
                            title: 'notice'.tr,
                            middleText: 'your_mode_is_manual'.tr,
                            confirm: ElevatedButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'ok'.tr,
                                style: TextStyle(color: ThemeColor().actual),
                              ),
                            ),
                          );
                        } else {
                          _mqttController.showDayAndHourPicker(
                            context,
                            'system_operation_scheduling',
                            onUpdated: () =>
                                _mqttController.buildJsonPayloadDXPressure(),
                          );
                        }
                      },
                      child: buildIconContainer(
                        context,
                        Icons.calendar_month,
                        _mqttController.toggleValue.value
                            ? Color(0xFF24C48E)
                            : Colors.grey,
                        Colors.grey.shade200,
                        _mqttController.toggleValue.value
                            ? 'enabled'.tr
                            : 'disabled'.tr,
                        _mqttController.toggleValue.value &&
                                _mqttController.timematch.value
                            ? Colors.green
                            : _mqttController.toggleValue.value &&
                                    !_mqttController.timematch.value
                                ? Colors.red
                                : Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                        showTick: _mqttController.toggleValue.value,
                        tickColor: _mqttController.scheduleTickColor,
                      ),
                    )),
                     GestureDetector(
                  onTap: () {
                 Get.to(() => Inputoutput());
                  },
                 
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.dashboard,
                      Color(0xFF24C48E),
                      Colors.grey.shade200,
                     
                      _mqttController.isSummer.value
                          ? 'I/O'.tr
                          : 'I/O'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildIconContainer(
  BuildContext context,
  IconData icon,
  Color iconColor,
  Color color,
  String text,
  Color txtcolor, {
  bool showTick = false,
  Color tickColor = Colors.grey,
}) {
  final media = MediaQuery.of(context);
  final isPortrait = media.orientation == Orientation.portrait;
  final baseSize = isPortrait ? media.size.height : media.size.width;
  final shortestSide = media.size.shortestSide;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: baseSize * 0.05,
            width: shortestSide * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(icon, color: iconColor),
          ),
          if (showTick)
            Positioned(
              bottom: -5,
              right: -5,
              child: Icon(
                Icons.check_circle,
                color: tickColor,
                size: 18,
              ),
            ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        text.tr,
        style: TextStyle(
          color: txtcolor,
        ),
      ),
    ],
  );
}

class DxPasswordDialog extends StatefulWidget {
  const DxPasswordDialog({
    super.key,
  });
  @override
  // ignore: library_private_types_in_public_api
  _DxPasswordDialogState createState() => _DxPasswordDialogState();
}

class _DxPasswordDialogState extends State<DxPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool _obscureText = true;

  void _checkPassword() {
    if (_passwordController.text == '9753') {
      Get.back();
      Get.to(() => DxSettingScreen());
    } else if (_passwordController.text == '1234') {
      Get.back();
      Get.to(() => DxUserscreen());
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
