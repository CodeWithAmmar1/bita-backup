import 'dart:async';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/chw/chw.dart';
import 'package:testappbita/Views/DX_master/circuits_widget/circuit.dart';
import 'package:testappbita/Views/DX_master/circuits_widget/circuit2.dart';
import 'package:testappbita/Views/DX_master/input_output/input_output.dart';
import 'package:testappbita/Views/DX_master/notification_screen/notification_dm.dart';
import 'package:testappbita/Views/DX_master/setting/setting.dart';
import 'package:testappbita/Views/DX_master/user_setting/user_setting.dart';
import 'package:testappbita/Views/Device/device.dart';
import 'package:testappbita/Views/aqua%20master/main_screen/mainpage.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/dm_notification_controller/dm_notification_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class MainScreenDxMaster extends StatefulWidget {
  const MainScreenDxMaster({super.key});
  @override
  State<MainScreenDxMaster> createState() => _MainScreenDxMasterState();
}

late String deviceName;
late String deviceid;

class _MainScreenDxMasterState extends State<MainScreenDxMaster> {
  final MqttController _mqttController = Get.find<MqttController>();
  final DmNotificationController _notificationControllerDm =
      Get.find<DmNotificationController>();

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
    final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    Timer? publishTimer;
    final isDark = Get.isDarkMode;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  Obx(
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
                              '${_notificationControllerDm.deviceNotificationMapDm[deviceid]?.length ?? 0}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            child: CustomIconButton(
                              nextcolor: Colors.black,
                              backgroundcolor1: Colors.grey.withOpacity(0.2),
                              color: Colors.black,
                              icon: Icons.notifications,
                              onPressed: () {
                                Get.to(() => NotificationDm(
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
                  Padding(
                    padding: EdgeInsets.all(Get.width * 0.02),
                    child: Container(
                      width: Get.width * 0.95,
                      padding: EdgeInsets.all(Get.width * 0.03),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? ThemeColor().mode2Sec
                            : ThemeColor().mode1Sec,
                        borderRadius: BorderRadius.circular(Get.width * 0.03),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _mqttController.dmStatusShow.value =
                                !_mqttController.dmStatusShow.value;
                          },
                          child: Text(
                            "DX-MASTER",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: constraints.maxWidth * 0.95,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
                      ),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "${'compressor_status'.tr} :",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            !_mqttController.circuitAenable.value &&
                                    !_mqttController.circuitBenable.value
                                ? Text(
                                    "Please Enable Circuit".tr,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  )
                                : _mqttController.dmStatusShow.value
                                    ? _mqttController.circuitBenable.value
                                        ? Text(
                                            _mqttController.deviceConnections[
                                                        deviceid] ??
                                                    false
                                                ? _mqttController
                                                            .dmStatusB.value ==
                                                        0
                                                    ? 'off'.tr
                                                    : _mqttController.dmStatusB
                                                                .value ==
                                                            1
                                                        ? 'starting'.tr
                                                        : _mqttController
                                                                    .dmStatusB
                                                                    .value ==
                                                                2
                                                            ? 'on'.tr
                                                            : _mqttController
                                                                        .dmStatusB
                                                                        .value ==
                                                                    3
                                                                ? 'stopping'.tr
                                                                : _mqttController
                                                                            .dmStatusB
                                                                            .value ==
                                                                        4
                                                                    ? 'tripped'
                                                                        .tr
                                                                    : _mqttController.dmStatusB.value ==
                                                                            5
                                                                        ? 'auto_stopped'
                                                                            .tr
                                                                        : _mqttController.dmStatusB.value ==
                                                                                6
                                                                            ? 'Disabled'.tr
                                                                            : _mqttController.dmStatusB.value == 7
                                                                                ? 'Suc Low Temp'.tr
                                                                                : _mqttController.dmStatusB.value == 8
                                                                                    ? 'Dis High Temp'.tr
                                                                                    : _mqttController.dmStatusB.value == 9
                                                                                        ? 'Suc Low Psi'.tr
                                                                                        : _mqttController.dmStatusB.value == 10
                                                                                            ? 'Dis High Psi'.tr
                                                                                            : _mqttController.dmStatusB.value == 11
                                                                                                ? 'Comp High Amp'.tr
                                                                                                : _mqttController.dmStatusB.value == 12
                                                                                                    ? 'Spray Low Temp'.tr
                                                                                                    : _mqttController.dmStatusB.value == 13
                                                                                                        ? 'oil_ps_low'.tr
                                                                                                        : 'Tripped'.tr
                                                : "--",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _mqttController.dmStatusB
                                                                    .value ==
                                                                1 ||
                                                            _mqttController
                                                                    .dmStatusB
                                                                    .value ==
                                                                2 ||
                                                            _mqttController
                                                                    .dmStatusB
                                                                    .value ==
                                                                5
                                                        ? Colors.green
                                                        : Colors.redAccent),
                                          )
                                        : Text(
                                            _mqttController.deviceConnections[
                                                        deviceid] ??
                                                    false
                                                ? _mqttController
                                                            .dmStatusA.value ==
                                                        0
                                                    ? 'off'.tr
                                                    : _mqttController.dmStatusA
                                                                .value ==
                                                            1
                                                        ? 'starting'.tr
                                                        : _mqttController
                                                                    .dmStatusA
                                                                    .value ==
                                                                2
                                                            ? 'on'.tr
                                                            : _mqttController
                                                                        .dmStatusA
                                                                        .value ==
                                                                    3
                                                                ? 'stopping'.tr
                                                                : _mqttController
                                                                            .dmStatusA
                                                                            .value ==
                                                                        4
                                                                    ? 'tripped'
                                                                        .tr
                                                                    : _mqttController.dmStatusA.value ==
                                                                            5
                                                                        ? 'auto_stopped'
                                                                        : _mqttController.dmStatusA.value ==
                                                                                6
                                                                            ? 'Disabled'.tr
                                                                            : _mqttController.dmStatusA.value == 7
                                                                                ? 'Suc Low Temp'.tr
                                                                                : _mqttController.dmStatusA.value == 8
                                                                                    ? 'Dis High Temp'.tr
                                                                                    : _mqttController.dmStatusA.value == 9
                                                                                        ? 'Suc Low Psi'.tr
                                                                                        : _mqttController.dmStatusA.value == 10
                                                                                            ? 'Dis High Psi'.tr
                                                                                            : _mqttController.dmStatusA.value == 11
                                                                                                ? 'Comp High Amp'.tr
                                                                                                : _mqttController.dmStatusA.value == 12
                                                                                                    ? 'Spray Low Temp'.tr
                                                                                                    : _mqttController.dmStatusA.value == 13
                                                                                                        ? 'oil_ps_low'.tr
                                                                                                        : 'Tripped'.tr
                                                : "--",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _mqttController.dmStatusA
                                                                    .value ==
                                                                1 ||
                                                            _mqttController
                                                                    .dmStatusA
                                                                    .value ==
                                                                2 ||
                                                            _mqttController
                                                                    .dmStatusA
                                                                    .value ==
                                                                5
                                                        ? Colors.green
                                                        : Colors.redAccent),
                                          )
                                    : _mqttController.circuitAenable.value
                                        ? Text(
                                            _mqttController.deviceConnections[
                                                        deviceid] ??
                                                    false
                                                ? _mqttController
                                                            .dmStatusA.value ==
                                                        0
                                                    ? 'off'.tr
                                                    : _mqttController.dmStatusA
                                                                .value ==
                                                            1
                                                        ? 'Starting'.tr
                                                        : _mqttController
                                                                    .dmStatusA
                                                                    .value ==
                                                                2
                                                            ? 'on'.tr
                                                            : _mqttController
                                                                        .dmStatusA
                                                                        .value ==
                                                                    3
                                                                ? 'stopping'.tr
                                                                : _mqttController
                                                                            .dmStatusA
                                                                            .value ==
                                                                        4
                                                                    ? 'tripped'
                                                                        .tr
                                                                    : _mqttController.dmStatusA.value ==
                                                                            5
                                                                        ? 'auto_stopped'
                                                                            .tr
                                                                        : _mqttController.dmStatusA.value ==
                                                                                6
                                                                            ? 'Disabled'.tr
                                                                            : _mqttController.dmStatusA.value == 7
                                                                                ? 'Suc Low Temp'.tr
                                                                                : _mqttController.dmStatusA.value == 8
                                                                                    ? 'Dis High Temp'.tr
                                                                                    : _mqttController.dmStatusA.value == 9
                                                                                        ? 'Suc Low Psi'.tr
                                                                                        : _mqttController.dmStatusA.value == 10
                                                                                            ? 'Dis High Psi'.tr
                                                                                            : _mqttController.dmStatusA.value == 11
                                                                                                ? 'Comp High Amp'.tr
                                                                                                : _mqttController.dmStatusA.value == 12
                                                                                                    ? 'Spray Low Temp'.tr
                                                                                                    : _mqttController.dmStatusA.value == 13
                                                                                                        ? 'oil_ps_low'.tr
                                                                                                        : 'Tripped'.tr
                                                : "--",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _mqttController.dmStatusA
                                                                    .value ==
                                                                1 ||
                                                            _mqttController
                                                                    .dmStatusA
                                                                    .value ==
                                                                2 ||
                                                            _mqttController
                                                                    .dmStatusA
                                                                    .value ==
                                                                5
                                                        ? Colors.green
                                                        : Colors.redAccent),
                                          )
                                        : Text(
                                            _mqttController.deviceConnections[
                                                        deviceid] ??
                                                    false
                                                ? _mqttController
                                                            .dmStatusB.value ==
                                                        0
                                                    ? 'off'.tr
                                                    : _mqttController.dmStatusB
                                                                .value ==
                                                            1
                                                        ? 'Starting'.tr
                                                        : _mqttController
                                                                    .dmStatusB
                                                                    .value ==
                                                                2
                                                            ? 'on'.tr
                                                            : _mqttController
                                                                        .dmStatusB
                                                                        .value ==
                                                                    3
                                                                ? 'Stopping'.tr
                                                                : _mqttController
                                                                            .dmStatusB
                                                                            .value ==
                                                                        4
                                                                    ? 'Tripped'
                                                                        .tr
                                                                    : _mqttController.dmStatusB.value ==
                                                                            5
                                                                        ? 'Auto_stopped'
                                                                            .tr
                                                                        : _mqttController.dmStatusB.value ==
                                                                                6
                                                                            ? 'Disabled'.tr
                                                                            : _mqttController.dmStatusB.value == 7
                                                                                ? 'Suc Low Temp'.tr
                                                                                : _mqttController.dmStatusB.value == 8
                                                                                    ? 'Dis High Temp'.tr
                                                                                    : _mqttController.dmStatusB.value == 9
                                                                                        ? 'Suc Low Psi'.tr
                                                                                        : _mqttController.dmStatusB.value == 10
                                                                                            ? 'Dis High Psi'.tr
                                                                                            : _mqttController.dmStatusB.value == 11
                                                                                                ? 'Comp High Amp'.tr
                                                                                                : _mqttController.dmStatusB.value == 12
                                                                                                    ? 'Spray Low Temp'.tr
                                                                                                    : _mqttController.dmStatusB.value == 13
                                                                                                        ? 'oil_ps_low'.tr
                                                                                                        : 'Tripped'.tr
                                                : "--",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _mqttController.dmStatusB
                                                                    .value ==
                                                                1 ||
                                                            _mqttController
                                                                    .dmStatusB
                                                                    .value ==
                                                                2 ||
                                                            _mqttController
                                                                    .dmStatusB
                                                                    .value ==
                                                                5
                                                        ? Colors.green
                                                        : Colors.redAccent),
                                          )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Chw(deviceid: deviceid),
                  Obx(
                    () => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: () {},
                      onTap: () {
                        _mqttController.toggleCircuitView();
                        log("Circuit Info View Toggled: ${_mqttController.dmStatusShow.value}");
                        log("Circuit Info  A Enable: ${_mqttController.circuitAenable.value},\n Circuit Info B Enable: ${_mqttController.circuitBenable.value}");
                      },
                      child: AbsorbPointer(
                        child: GestureFlipCard(
                            controller: _mqttController.flipController,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            axis: FlipAxis.vertical,
                            enableController: true,
                            frontWidget: (_mqttController
                                        .circuitAenable.value &&
                                    !_mqttController.dmStatusShow.value)
                                ? Center(
                                    child: Circuit(
                                    deviceid: deviceid,
                                  ))
                                : (!_mqttController.circuitBenable.value &&
                                        !_mqttController.circuitAenable.value)
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 48.0),
                                          child: Text(
                                            "Please Enable Circuit",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Circuit2(
                                        deviceid: deviceid,
                                      ),
                            backWidget: (_mqttController.circuitBenable.value &&
                                    _mqttController.dmStatusShow.value)
                                ? Circuit2(
                                    deviceid: deviceid,
                                  )
                                : (!_mqttController.circuitBenable.value &&
                                        !_mqttController.circuitAenable.value)
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 48.0),
                                          child: Text(
                                            "Please Enable Circuit",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Circuit(
                                        deviceid: deviceid,
                                      ))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
                    if (_mqttController.dmPower.value == 1) {
                      _mqttController.isUserInteracting.value = true;
                      _mqttController.dmPower.value = 0;
                      log("DM Power Off${_mqttController.dmPower.value}");
                      _mqttController.buildJsonPayloadDXMaster();
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 1), () {
                        log("DM Power Payload Published--${_mqttController.dmPower.value}");
                        _mqttController.isUserInteracting.value = false;
                      });
                    } else {
                      _mqttController.dmPower.value = 1;
                      _mqttController.isUserInteracting.value = true;
                      log("DM Power On${_mqttController.dmPower.value}");
                      _mqttController.buildJsonPayloadDXMaster();
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 1), () {
                        log("DM Power Payload Published--${_mqttController.dmPower.value}");
                        _mqttController.isUserInteracting.value = false;
                      });
                    }
                  },
                  child: Obx(
                    () => buildIconContainer(
                      context,
                      Icons.power_settings_new,
                      _mqttController.dmPower.value == 0
                          ? Color(0xFF24C48E)
                          : Colors.red,
                      Colors.grey.shade200,
                      _mqttController.dmPower.value == 0
                          ? 'start'.tr
                          : 'stop'.tr,
                      Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      _mqttController.dmResetload.value = true;
                      _mqttController.dmResetValues.value = 1;
                      _mqttController.buildJsonPayloadDXMaster();
                      publishTimer?.cancel();
                      publishTimer = Timer(Duration(seconds: 5), () {
                        _mqttController.dmResetload.value = false;
                        _mqttController.isUserInteracting.value = false;
                      });
                      log("DM Reset Pressed${_mqttController.dmResetValues.value}");
                    },
                    child: buildIconContainer(
                      context,
                      _mqttController.dmResetload.value
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
                    Get.to(() => InputOutput());
                  },
                  child: buildIconContainer(
                    context,
                    Icons.layers_outlined,
                    Color(0xFF24C48E),
                    Colors.grey.shade200,
                    'I/O'.tr,
                    Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackWidget() {
    if (_mqttController.circuitBenable.value &&
        _mqttController.dmStatusShow.value) {
      return Center(child: Circuit2(deviceid: deviceid));
    }

    if (_mqttController.circuitAenable.value &&
        !_mqttController.dmStatusShow.value) {
      return Center(child: Circuit(deviceid: deviceid));
    }

    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.0),
        child: Text(
          "Please Enable Circuit",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildFrontWidget() {
    if (_mqttController.circuitAenable.value &&
        !_mqttController.dmStatusShow.value) {
      return Center(child: Circuit(deviceid: deviceid));
    }

    if (_mqttController.circuitBenable.value &&
        _mqttController.dmStatusShow.value) {
      return Center(child: Circuit2(deviceid: deviceid));
    }

    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.0),
        child: Text(
          "Please Enable Circuit",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PasswordDialog1 extends StatefulWidget {
  final String deviceId;
  const PasswordDialog1({super.key, required this.deviceId});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordDialog1State createState() => _PasswordDialog1State();
}

class _PasswordDialog1State extends State<PasswordDialog1> {
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool _obscureText = true;

  void _checkPassword() {
    if (_passwordController.text == '9753') {
      Get.back();
      Get.to(() => Setting());
    } else if (_passwordController.text == '1234') {
      Get.back();
      Get.to(() => UserSetting());
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
