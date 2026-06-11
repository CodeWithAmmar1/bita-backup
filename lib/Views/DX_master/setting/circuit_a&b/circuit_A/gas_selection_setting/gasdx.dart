import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/gas_selection_setting/gas_sheet.dart';
import 'package:testappbita/controller/sensor_switch_controller/sensor_switch_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class Gasdx extends StatefulWidget { final bool permission;
  final bool permissiongas;
  final RxInt gas;
  const Gasdx({super.key, required this.gas, required this.permissiongas, required this.permission});

  @override
  State<Gasdx> createState() => _SettingPageState();
}

class _SettingPageState extends State<Gasdx> {
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
                  gasSheet(context, widget.gas, widget.permissiongas,widget.permission);
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
