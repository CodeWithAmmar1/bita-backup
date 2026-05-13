import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/exv_setting/exv_setting.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/gas_selection_setting/gasdx.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/setpoint_setting/systemsetpointB.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_b_user/sensorselectionB/sensorselectionDmB.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_b_user/vendorb_settings/b_pressure_configuration/b_pressure_sensors_configuration.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_b_user/vendorb_settings/driveb_setting/drive_b_setting.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CircuitChmB extends StatefulWidget {
  const CircuitChmB({super.key});

  @override
  State<CircuitChmB> createState() => _CircuitAState();
}

class _CircuitAState extends State<CircuitChmB> {
  final MqttController _mqttController = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
        appBar: AppBar(
          backgroundColor: ThemeColor().actual,
          centerTitle: true,
          title: Text(
            'Circuit B Setting',
            style: TextStyle(
                fontSize: Get.width * 0.06,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Get.to(() => DriveBSetting());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'Drive Settings'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),    SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => SensorselectiondmB());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'tempSensorsSetting'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => BPressureSensorsConfiguration());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'Pressure Sensor Configuration'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => Systemsetpointb());
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'System Setpoints'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => ExvSetting(
                        exvcurrentStep: _mqttController.exvCurrentStepB,
                        exvmaxstep: _mqttController.exvMaxStepB,
                        exvstepDelay: _mqttController.exvStepDelayB,
                        min: _mqttController.minValueB,
                        max: _mqttController.maxValueB,
                        derivative: _mqttController.derivativespB,
                        integral: _mqttController.integralspB,
                        proportional: _mqttController.propostionalspB,
                        superHeat: _mqttController.superHeatspB,
                        permissionExv: false,
                        disPressure: _mqttController.dmdischargePressureB,
                        disTemp: _mqttController.dmdischargeTempB,
                        selectedEXVMode: _mqttController.selectedEXVModeB,
                        sucPressure: _mqttController.dmSuctionPressureB,
                        sucTemp: _mqttController.dmSuctionTempB,
                      ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'EXV Settings'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => Gasdx(
                        permissiongas: false,
                        gas: _mqttController.gasB,
                      ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  title: Text(
                    'Gas Selections'.tr,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ));
  }
}
