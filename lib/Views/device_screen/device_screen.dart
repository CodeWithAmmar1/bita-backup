import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/device_screen/custom_widget/device_card.dart';
import 'package:testappbita/services/firebase_service.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<DeviceModel> allDeviceData = [];

  void getTaskListner() {
    SharedPreferencesService().listenToUserDevices().listen((allTask) {
      debugPrint('Received Data: $allTask');
      setState(() {
        allDeviceData = allTask;
      });
    }, onError: (error) {
      debugPrint('Error in Listener: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    getTaskListner();
  }

  void _showEditNameDialog(BuildContext context, DeviceModel device) {
    final TextEditingController nameController =
        TextEditingController(text: device.deviceName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Text(
            'editDeviceName'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'enter_new_name'.tr),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "cancel".tr,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            TextButton(
              child: Text(
                'save'.tr,
                style: TextStyle(color: ThemeColor().actual),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await SharedPreferencesService().updateDeviceName(
                    deviceId: device.deviceId ?? "",
                    newName: nameController.text,
                  );
                  Navigator.of(context).pop();
                  getTaskListner();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "device_list".tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: allDeviceData.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.2),
                child: Text('No Device Added'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: allDeviceData.length,
                itemBuilder: (context, index) {
                  final device = allDeviceData[index];

                  return DeviceCard(
                      title: '${allDeviceData[index].deviceName}',
                      macAddress: '${allDeviceData[index].deviceMac}',
                      deviceId: '${allDeviceData[index].deviceId}',
                      ipAddress: '${allDeviceData[index].deviceIp}',
                      onSetting: () {
                        _showEditNameDialog(context, device);
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                Theme.of(context).dialogBackgroundColor,
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
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferencesService().deleteDeviceData(
                                      deviceId: device.deviceId ?? "");
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
                      });
                },
              ),
            ),
    );
  }
}
