import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/aqua%20master/customize_card/switch_card_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';

class CoolerViewSetting extends StatelessWidget {
  final String deviceid;
  final int index;
  CoolerViewSetting({super.key, required this.index, required this.deviceid});

  final MqttController mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String temp2 = mqttController.comfortAndCoolerTemp.value;
      return SwitchCardSettingNew(
        deviceid: deviceid,
        value: double.tryParse(temp2) ?? 0.0,
        index: index,
        heading: 'cooler'.tr,
        title: mqttController.deviceConnections[deviceid] ?? false
            ? (temp2 == "999.9" ? "None" : "$temp2°C")
            : "--",
        temp: mqttController.coolerSp,
      );
    });
  }
}
