import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/gas_selection_setting/gas_sheet.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class GasdxChm extends StatefulWidget {
  final bool permissiongas;
  final RxInt gas;
  const GasdxChm({super.key, required this.gas, required this.permissiongas});

  @override
  State<GasdxChm> createState() => _SettingPageState();
}

class _SettingPageState extends State<GasdxChm> {
  final SensorSwitchController controller = Get.put(SensorSwitchController());

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  gasSheet(context, widget.gas, widget.permissiongas);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: textColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: textColor,
                    size: 20,
                  ),
                  title: Text(
                    'gas_selection'.tr,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
