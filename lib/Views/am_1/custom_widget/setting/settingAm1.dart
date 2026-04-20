import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/hide_unhide.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/modeSwitch.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/returnTempSelection.dart';
import 'package:testappbita/Views/am1-444/sensorselectionAm1.dart';
import 'package:testappbita/Views/am_1/custom_widget/setting/temp_selectionAm1.dart';
import 'package:testappbita/Views/am_1/widget/gass.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class SettingAm1 extends StatefulWidget {
  final bool isFromDevicePage;
  const SettingAm1({super.key, required this.isFromDevicePage});

  @override
  State<SettingAm1> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingAm1> {
  final SensorSwitchController controller = Get.put(SensorSwitchController());
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        centerTitle: true,
        title: Text(
          'settings'.tr,
          style: TextStyle(
            color: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        bool isDisabled = _mqttController.comprsw.value == 1;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(() => Modeswitch());
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
                    'operation_mode_selection'.tr,
                    style:
                        TextStyle(color: isDisabled ? Colors.grey : textColor),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        if (widget.isFromDevicePage) {
                          Get.to(() => Sensorselectionam1());
                        } else {
                          Get.to(() => TempSelectionam1());
                        }
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
                    'tempSensorsSetting'.tr,
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        showGasSelector(context);
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
                    'gas_selection'.tr,
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        Get.to(() => HideUnhide());
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
                    'enableDisableConfig'.tr,
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Obx(() {
                if (_mqttController.isModeSwitchAm1.value) {
                  return GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () {
                            Get.to(() => Returntempselection());
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
                        'Return Temp Selection'.tr,
                        style: TextStyle(
                          color: isDisabled ? Colors.grey : textColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
