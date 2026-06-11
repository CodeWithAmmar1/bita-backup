import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/circuit_a.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_b_user/vendorb_settings/circuit_b.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Setting extends StatefulWidget {
  final String sub;
  final String sup;
  final String ret;
  final String val1A;
  final bool permission;
  final String exvtitle;
  final String exvleft;
  final String exvright;
  const Setting(
      {super.key,
      required this.permission,
      required this.exvtitle,
      required this.exvleft,
      required this.exvright, required this.val1A, required this.sub, required this.sup, required this.ret});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'System Setting',
            style: TextStyle(
                fontSize: Get.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Obx(() {
            bool isDisabled = _mqttController.dmStatusA.value == 2;
            return Column(
              children: [
                SizedBox(height: 10),
                if (_mqttController.circuitAenable.value == true)
                  SizedBox(height: Get.height * 0.02),
                if (_mqttController.circuitAenable.value == true)
                  GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () {
                            Get.to(() => CircuitA(
                                  sub: widget.sub,
                                  sup: widget.sup,
                                  ret: widget.ret,
                               val1A: widget.val1A,
                                  permission: widget.permission,
                                  exvtitle: widget.exvtitle,
                                  exvleft: widget.exvleft,
                                  exvright: widget.exvright,
                                ));
                          },
                    child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: isDisabled ? Colors.grey : textColor,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isDisabled ? Colors.grey : textColor,
                        size: 20,
                      ),
                      title: Text(
                        'Circuit A'.tr,
                        style: TextStyle(
                          color: isDisabled ? Colors.grey : textColor,
                        ),
                      ),
                    ),
                  ),
                if (_mqttController.circuitBenable.value == true)
                  SizedBox(height: Get.height * 0.02),
                if (_mqttController.circuitBenable.value == true)
                  GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () {
                            Get.to(() =>  CircuitB(
                                  exvtitle: widget.exvtitle ,
                                  exvleft: widget.exvleft,
                                  exvright: widget.exvright,
                                ));
                          },
                    child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: isDisabled ? Colors.grey : textColor,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isDisabled ? Colors.grey : textColor,
                        size: 20,
                      ),
                      title: Text(
                        'Circuit B'.tr,
                        style: TextStyle(
                          color: isDisabled ? Colors.grey : textColor,
                        ),
                      ),
                    ),
                  )
              ],
            );
          }),
        ));
  }
}
