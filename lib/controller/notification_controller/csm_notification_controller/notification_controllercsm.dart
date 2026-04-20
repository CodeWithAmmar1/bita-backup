import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationControllercsm extends GetxController {
  RxMap<String, List<NotificationContent>> deviceNotificationMapCsm =
      <String, List<NotificationContent>>{}.obs;
  @override
  void onInit() {
    super.onInit();
    loadNotificationsFromPrefs();
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy hh:mm a').format(now);
  }

  Future<void> addNotification(
      String deviceId, NotificationContent content) async {
    if (!deviceNotificationMapCsm.containsKey(deviceId)) {
      deviceNotificationMapCsm[deviceId] = [];
    }
    deviceNotificationMapCsm[deviceId]!.insert(0, content);
    deviceNotificationMapCsm.refresh();
    await saveNotificationsToPrefs();
  }

  Future<void> clearNotifications(String deviceId) async {
    deviceNotificationMapCsm[deviceId]?.clear();
    deviceNotificationMapCsm.refresh();
    await saveNotificationsToPrefs();
  }

  Future<void> removeNotification(String deviceId, int index) async {
    deviceNotificationMapCsm[deviceId]?.removeAt(index);
    deviceNotificationMapCsm.refresh();
    await saveNotificationsToPrefs();
  }

  void showTemperatureAlertNotification(
      String deviceId, String title, double temperature, String status) {
    final content = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'temperature_alerts',
      title: '$deviceId Alert:',
      body:
          '$title Temp. - $status (${temperature.toStringAsFixed(1)}°C)\n${getCurrentDateTime()}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      wakeUpScreen: true,
    );
    AwesomeNotifications().createNotification(content: content);
    addNotification(deviceId, content);
  }



  Future<void> saveNotificationsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> encodedMap = {};

    deviceNotificationMapCsm.forEach((key, list) {
      encodedMap[key] =
          list.map((noti) => jsonEncode(_notificationToJson(noti))).toList();
    });

    await prefs.setString('deviceNotificationMapCsm', jsonEncode(encodedMap));
  }

  Future<void> loadNotificationsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('deviceNotificationMapCsm');

    if (encodedData != null) {
      Map<String, dynamic> rawMap = jsonDecode(encodedData);
      rawMap.forEach((key, value) {
        List<NotificationContent> list = (value as List)
            .map((e) => _notificationFromJson(jsonDecode(e)))
            .toList();
        deviceNotificationMapCsm[key] = list;
      });
      deviceNotificationMapCsm.refresh();
    }
  }

  Map<String, dynamic> _notificationToJson(NotificationContent content) {
    return {
      'id': content.id,
      'channelKey': content.channelKey,
      'title': content.title,
      'body': content.body,
      'notificationLayout': content.notificationLayout?.name,
      'autoDismissible': content.autoDismissible,
      'wakeUpScreen': content.wakeUpScreen,
    };
  }

  NotificationContent _notificationFromJson(Map<String, dynamic> json) {
    return NotificationContent(
      id: json['id'],
      channelKey: json['channelKey'],
      title: json['title'],
      body: json['body'],
      notificationLayout: NotificationLayout.values.firstWhere(
        (e) => e.name == json['notificationLayout'],
        orElse: () => NotificationLayout.Default,
      ),
      autoDismissible: json['autoDismissible'] ?? true,
      wakeUpScreen: json['wakeUpScreen'] ?? false,
    );
  }
}
