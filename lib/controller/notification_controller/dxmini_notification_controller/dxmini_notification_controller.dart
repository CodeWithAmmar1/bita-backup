import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DxminiNotificationController extends GetxController {
  RxMap<String, List<NotificationContent>> deviceNotificationMapDxm =
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
    if (!deviceNotificationMapDxm.containsKey(deviceId)) {
      deviceNotificationMapDxm[deviceId] = [];
    }
    deviceNotificationMapDxm[deviceId]!.insert(0, content);
    deviceNotificationMapDxm.refresh();
    await saveNotificationsToPrefs();
  }

  Future<void> clearNotifications(String deviceId) async {
    deviceNotificationMapDxm[deviceId]?.clear();
    deviceNotificationMapDxm.refresh();
    await saveNotificationsToPrefs();
  }

  Future<void> removeNotification(String deviceId, int index) async {
    deviceNotificationMapDxm[deviceId]?.removeAt(index);
    deviceNotificationMapDxm.refresh();
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

    deviceNotificationMapDxm.forEach((key, list) {
      encodedMap[key] =
          list.map((noti) => jsonEncode(_notificationToJson(noti))).toList();
    });

    await prefs.setString('deviceNotificationMapDxm', jsonEncode(encodedMap));
  }

  Future<void> loadNotificationsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('deviceNotificationMapDxm');

    if (encodedData != null) {
      Map<String, dynamic> rawMap = jsonDecode(encodedData);
      rawMap.forEach((key, value) {
        List<NotificationContent> list = (value as List)
            .map((e) => _notificationFromJson(jsonDecode(e)))
            .toList();
        deviceNotificationMapDxm[key] = list;
      });
      deviceNotificationMapDxm.refresh();
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
