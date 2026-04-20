import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/rcm_notification_controller/rcm_notification_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class RcmNotification extends StatelessWidget {
  final String deviceid;
  final RcmNotificationController _notificationController =
      Get.find<RcmNotificationController>();
  final MqttController _mqttController = Get.find<MqttController>();
  RcmNotification({super.key, required this.deviceid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? ThemeColor().mode2 : ThemeColor().mode1,
      appBar: AppBar(
        backgroundColor: ThemeColor().actual,
        automaticallyImplyLeading: false,
        title: Text(
          'notifications'.tr,
          style: TextStyle(
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever,
                color: Get.isDarkMode ? Colors.black : Colors.white),
            onPressed: () {
              Get.defaultDialog(
                title: 'delete_all'.tr,
                middleText: 'delete_all_notifications_question'.tr,
                textConfirm: 'yes'.tr,
                textCancel: 'no'.tr,
                confirmTextColor: Colors.white,
                onConfirm: () {
                  _notificationController.clearNotifications(deviceid);
                  _mqttController.clearLastNotifiedValuesRcm(deviceid);
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final history =
            _notificationController.deviceNotificationMapRcm[deviceid] ?? [];

        if (history.isEmpty) {
          return Center(
              child: Text('no_notifications_yet'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  )));
        }
        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final notif = history[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                tileColor: Get.isDarkMode
                    ? ThemeColor().mode2Sec
                    : ThemeColor().mode1Sec,
                leading: Icon(
                  Icons.notifications,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(notif.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    )),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((notif.body?.split('\n').first) ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: Get.isDarkMode ? Colors.white : Colors.red,
                        )),
                    Text(
                        (notif.body?.split('\n').length ?? 0) > 1
                            ? notif.body!.split('\n')[1]
                            : '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        )),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _notificationController.removeNotification(deviceid, index);
                    _mqttController.clearLastNotifiedValuesRcm(deviceid);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}