import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/drive_selection/drive_setting.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/exv_setting/exv_setting.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/gas_selection_setting/gasdx.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/pressure_configration/pressure_sensorconfiguration.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/sensorselectionA/sensorselectionDmA.dart';
import 'package:testappbita/Views/DX_master/setting/circuit_a&b/circuit_A/setpoint_setting/systemsetpointA.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class CircuitChmA extends StatefulWidget {
  const CircuitChmA({super.key});

  @override
  State<CircuitChmA> createState() => _CircuitChmAState();
}

class _CircuitChmAState extends State<CircuitChmA> {
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
            'Circuit A Setting',
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
                  Get.to(() => DriveASetting());
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
              ),
               SizedBox(height: Get.height * 0.02),
              GestureDetector(
                onTap: () {
                  Get.to(() => SensorselectiondmA());
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
                  Get.to(() => PressureSensorconfiguration());
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
                  Get.to(() => Systemsetpointa());
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
                    exvcurrentStep: _mqttController.exvCurrentStepA,
                    exvmaxstep: _mqttController.exvMaxStepA,
                    exvstepDelay: _mqttController.exvStepDelayA,
                        min: _mqttController.minValueA,
                        max: _mqttController.maxValueA,
                        derivative: _mqttController.derivativespA,
                        integral: _mqttController.integralspA,
                        proportional: _mqttController.propostionalspA,
                        superHeat: _mqttController.superHeatspA,
                        permissionExv: true,
                        disPressure: _mqttController.dmdischargePressureA,
                        disTemp: _mqttController.dmdischargeTempA,
                        selectedEXVMode: _mqttController.selectedEXVModeA,
                        sucPressure: _mqttController.dmSuctionPressureA,
                        sucTemp: _mqttController.dmSuctionTempA,
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
                        permissiongas: true,
                        gas: _mqttController.gasA,
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
