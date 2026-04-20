import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/telecome/telecom_dashboard.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/services/firebase_service.dart';

class TelecomeCard extends StatelessWidget {
  final DeviceModel device;
  TelecomeCard({super.key, required this.device});
  final MqttController _mqttcontroller = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Obx(
      () => Card(
        color: Theme.of(context).cardColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                isDarkMode ? Colors.grey.withValues(alpha: 0.2) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.1
                        : 0.2),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => TelecomDashboard(), arguments: {
                "name": "${device.deviceName}",
                "id": "${device.deviceId}"
              });
              _mqttcontroller.updatetopicSSIDvalue(device.deviceId ?? "");
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  title: Text(
                    "delete_device".tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text("delete_device_prompt".tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "cancel".tr,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        SharedPreferencesService()
                            .deleteDeviceData(deviceId: device.deviceId ?? "");
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "delete".tr,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/images/telecome.png",
                              width: 45,
                              height: 45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            device.deviceName ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _mqttcontroller
                                          .deviceConnections[device.deviceId] ??
                                      false
                                  ? 'online'.tr
                                  : 'offline'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: _mqttcontroller.deviceConnections[
                                            device.deviceId] ??
                                        false
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              device.deviceId ?? "",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
