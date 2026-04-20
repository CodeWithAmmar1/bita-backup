import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/aqua%20master/customize_card/switch_card_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';

class BoilerViewSetting extends StatelessWidget {
  final String deviceid;
  final int index;
  BoilerViewSetting({super.key, required this.index, required this.deviceid});

  final MqttController mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp1 = mqttController.boilerTemp.value;
      return SwitchCardSettingNew(
        deviceid: deviceid,
        index: index,
        heading: "boiler".tr,
        title: mqttController.deviceConnections[deviceid] ?? false
            ? (temp1 == "999.9" ? "None" : "$temp1°C")
            : "--",
        temp: mqttController.boilerSp,
        value: double.tryParse(temp1) ?? 0.0,
      );
    });
  }
}
