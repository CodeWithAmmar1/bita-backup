import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/userSettingAm1.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Returntempselection extends StatefulWidget {
  const Returntempselection({super.key});

  @override
  State<Returntempselection> createState() => _ReturntempselectionState();
}

final MqttController _mqttController = Get.find<MqttController>();

class _ReturntempselectionState extends State<Returntempselection> {
  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: isDark ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'Return Temp Selection'.tr,
          style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Obx(
            () => RestartToggle(
              LeftText: 'Temp Sensor'.tr,
              rightText: 'BECA'.tr,
              title: 'Return Temp Selection'.tr,
              value: _mqttController.isReturnTempam1.value,
              onTap: () async {
                _mqttController.am1autoReturnTempLoading.value = true;
                final newValue = !_mqttController.isReturnTempam1.value;
                await _mqttController.am1autoReturnTemp(newValue);
                _mqttController.am1autoReturnTempLoading.value = false;
                return newValue;
              },
            ),
          ),
        ],
      ),
    );
  }
}
