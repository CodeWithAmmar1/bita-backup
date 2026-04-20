import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/setting_screen/account_screen/account_screen.dart';
import 'package:testappbita/Views/setting_screen/language_button/language.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:testappbita/utils/theme/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

final themeController = Get.find<ThemeController>();

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream() {
    if (user != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .snapshots();
    }
    return const Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.12),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Get.isDarkMode
                        ? ThemeColor().mode2Sec
                        : ThemeColor().mode1Sec,
                    radius: 35,
                    backgroundImage: const AssetImage('assets/images/icon.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: _userStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Loading...",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text(
                                user?.displayName ?? "Your Name",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            final data = snapshot.data!.data();
                            final username = data?["username"] ??
                                user?.displayName ??
                                "Your Name";

                            return Text(
                              username,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        Text(
                          user?.email ?? "example@mail.com",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Get.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const AccountPage(),
                                arguments: {"image": "assets/images/icon.png"});
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'viewAccount'.tr,
                            style: TextStyle(
                                fontSize: 16, color: ThemeColor().actual),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey[900]
                      : const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Get.isDarkMode ? Colors.black26 : Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSettingItem(
                      icon: Icons.brightness_6,
                      title: 'display_mode'.tr,
                      trailing: Row(
                        children: [
                          Text(
                            "light".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Obx(() => Switch(
                                activeColor: Colors.black,
                                activeTrackColor: ThemeColor().actual,
                                value: themeController.isDarkMode.value,
                                onChanged: (value) {
                                  themeController.toggleTheme(value);
                                },
                              )),
                          SizedBox(width: 5),
                          Text(
                            "dark".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: 'language'.tr,
                      trailing: LanguageToggle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: theme.iconTheme.color),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
