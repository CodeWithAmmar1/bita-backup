import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappbita/Views/splash/splash_Screen.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/controller/notification_controller/am2_notification_controller/notification_controller.dart';
import 'package:testappbita/firebase_options.dart';
import 'package:testappbita/services/localization/localization.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'temperature_alerts',
        channelName: 'Temperature Alerts',
        channelDescription: 'Alert when temperature is too high or too low',
        defaultColor: Colors.red,
        importance: NotificationImportance.High,
      )
    ],
  );
  Get.put(NotificationController());
  await dotenv.load();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  Get.put(MqttController());

  runApp(MyApp(isDarkMode: isDarkMode));
}

Future<void> _requestPermissions() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    await Permission.camera.request();
  }
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  const MyApp({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: MyTranslations(),
        locale: Locale('en', 'US'),
        fallbackLocale: Locale('en', 'US'),
        theme: ThemeData(
          fontFamily: 'Roboto-Regular',
          brightness: Brightness.light,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 14),
            bodyMedium: TextStyle(fontSize: 12),
            titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Roboto-Regular',
          brightness: Brightness.dark,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 12, color: Colors.white70),
            titleLarge: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        home: Splash()));
  }
}
// API_KEY=4d358f5468b9de328a0f8d398826b3fa