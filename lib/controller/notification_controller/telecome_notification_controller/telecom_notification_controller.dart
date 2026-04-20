import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TelecomNotificationController extends GetxController {
  RxMap<String, List<NotificationContent>> deviceNotificationMapTel =
      <String, List<NotificationContent>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotificationsFromPrefsTel();
  }

  /// 🕓 Format current date & time
  String getCurrentDateTimeTel() {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy hh:mm a').format(now);
  }

  /// 💾 Save new notification for a specific device
  Future<void> addNotificationTel(
      String deviceId, NotificationContent content) async {
    if (!deviceNotificationMapTel.containsKey(deviceId)) {
      deviceNotificationMapTel[deviceId] = [];
    }
    deviceNotificationMapTel[deviceId]!.insert(0, content);
    deviceNotificationMapTel.refresh();
    await saveNotificationsToPrefsTel();
  }

  /// 🗑 Clear all notifications for a device
  Future<void> clearNotificationsTel(String deviceId) async {
    deviceNotificationMapTel[deviceId]?.clear();
    deviceNotificationMapTel.refresh();
    await saveNotificationsToPrefsTel();
  }

  /// ❌ Remove a specific notification
  Future<void> removeNotificationTel(String deviceId, int index) async {
    deviceNotificationMapTel[deviceId]?.removeAt(index);
    deviceNotificationMapTel.refresh();
    await saveNotificationsToPrefsTel();
  }

  // 🔔 H U M I D I T Y   A L E R T   N O T I F I C A T I O N
  void showHumidityAlertNotification(
      String deviceId, String title, String state, double value) {
    final content = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'temperature_alerts',
      title: '$deviceId Alert:',
      body:
          '$title - $state (${value.toStringAsFixed(0)}%RH)\n${getCurrentDateTimeTel()}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      wakeUpScreen: true,
    );
    AwesomeNotifications().createNotification(content: content);
    addNotificationTel(deviceId, content);
  }

  // 🔔 T E M P E R A T U R E   A L E R T   N O T I F I C A T I O N
  void showTemperatureAlertNotification(
    String deviceId,
    String title,
    String status,
    double temperature,
  ) {
    final content = NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'temperature_alerts',
      title: '$deviceId Alert:',
      body:
          '$title - $status (${temperature.toStringAsFixed(1)}°C)\n${getCurrentDateTimeTel()}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      wakeUpScreen: true,
    );
    AwesomeNotifications().createNotification(content: content);
    addNotificationTel(deviceId, content);
  }

  /// 💾 Save all notifications in SharedPreferences
  Future<void> saveNotificationsToPrefsTel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> encodedMap = {};

    deviceNotificationMapTel.forEach((key, list) {
      encodedMap[key] =
          list.map((noti) => jsonEncode(_notificationToJsonTel(noti))).toList();
    });

    await prefs.setString('deviceNotificationMapTel', jsonEncode(encodedMap));
  }

  /// 📦 Load notifications from SharedPreferences
  Future<void> loadNotificationsFromPrefsTel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('deviceNotificationMapTel');

    if (encodedData != null) {
      Map<String, dynamic> rawMap = jsonDecode(encodedData);
      rawMap.forEach((key, value) {
        List<NotificationContent> list = (value as List)
            .map((e) => _notificationFromJsonTel(jsonDecode(e)))
            .toList();
        deviceNotificationMapTel[key] = list;
      });
      deviceNotificationMapTel.refresh();
    }
  }

  /// 🔸 Convert notification to JSON
  Map<String, dynamic> _notificationToJsonTel(NotificationContent content) {
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

  /// 🔹 Convert JSON to notification object
  NotificationContent _notificationFromJsonTel(Map<String, dynamic> json) {
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
