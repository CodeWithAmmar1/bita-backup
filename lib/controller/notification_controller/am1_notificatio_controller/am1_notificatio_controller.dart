import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationControlleraM1 extends GetxController {
  RxMap<String, List<NotificationContent>> deviceNotificationMapAm1 =
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
    if (!deviceNotificationMapAm1.containsKey(deviceId)) {
      deviceNotificationMapAm1[deviceId] = [];
    }
    deviceNotificationMapAm1[deviceId]!.insert(0, content);
    deviceNotificationMapAm1.refresh();
    await saveNotificationsToPrefs();
  }

  Future<void> clearNotifications(String deviceId) async {
    deviceNotificationMapAm1[deviceId]?.clear();
    deviceNotificationMapAm1.refresh();
    await saveNotificationsToPrefs();
  }

  Future<void> removeNotification(String deviceId, int index) async {
    deviceNotificationMapAm1[deviceId]?.removeAt(index);
    deviceNotificationMapAm1.refresh();
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

  void showPressureAlertNotification(
      String deviceId, String title, double pressure, String status) {
    final content = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'temperature_alerts',
      title: '$deviceId Alert:',
      body:
          '$title Pressure - $status (${pressure.toStringAsFixed(0)} PSI)\n${getCurrentDateTime()}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      wakeUpScreen: true,
    );
    AwesomeNotifications().createNotification(content: content);
    addNotification(deviceId, content);
  }

  void showAmpereAlertNotification(
      String deviceId, String title, double ampere, String status) {
    final content = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'temperature_alerts',
      title: '$deviceId Alert:',
      body:
          'Compressor Current - $status (${ampere.toStringAsFixed(0)}A)\n${getCurrentDateTime()}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      wakeUpScreen: true,
    );
    AwesomeNotifications().createNotification(content: content);
    addNotification(deviceId, content);
  }

  void showSwitchAlertNotification(
      String deviceId, String title, String state, String value) {
    final content = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'temperature_alerts',
      title: '$deviceId Alert:',
      body: '$title $state $value \n${getCurrentDateTime()}',
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

    deviceNotificationMapAm1.forEach((key, list) {
      encodedMap[key] =
          list.map((noti) => jsonEncode(_notificationToJson(noti))).toList();
    });

    await prefs.setString('deviceNotificationMapAm1', jsonEncode(encodedMap));
  }

  Future<void> loadNotificationsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('deviceNotificationMapAm1');

    if (encodedData != null) {
      Map<String, dynamic> rawMap = jsonDecode(encodedData);
      rawMap.forEach((key, value) {
        List<NotificationContent> list = (value as List)
            .map((e) => _notificationFromJson(jsonDecode(e)))
            .toList();
        deviceNotificationMapAm1[key] = list;
      });
      deviceNotificationMapAm1.refresh();
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
