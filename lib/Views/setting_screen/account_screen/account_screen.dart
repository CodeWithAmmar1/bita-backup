import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/auth_controller/auth_controller.dart';
import 'package:testappbita/utils/theme/theme.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final AuthController _authController = Get.put(AuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  String username = "Your Name";
  String email = "Example@gmail.com";

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_user != null) {
      setState(() {
        email = _user!.email ?? "No Email";
      });

      DocumentSnapshot userDoc =
          await _firestore.collection("users").doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc["username"] ?? "Your Name";
        });
      }
    }
  }

  void _editUsername() {
    TextEditingController controller = TextEditingController(text: username);

    Get.dialog(
      AlertDialog(
        backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Edit Name",
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
          cursorColor: ThemeColor().actual,
          decoration: InputDecoration(
            labelText: "Enter new name",
            labelStyle: TextStyle(color: ThemeColor().actual),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeColor().actual),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Get.isDarkMode ? Colors.white54 : Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor().actual, // ✅ fixed
            ),
            onPressed: () async {
              String newName = controller.text.trim();
              if (newName.isNotEmpty && _user != null) {
                await _firestore.collection("users").doc(_user!.uid).set(
                    {"username": newName},
                    SetOptions(merge: true)); // ✅ safe update
                setState(() {
                  username = newName;
                });
              }
              Get.back();
            },
            child: const Text("Save",
                style: TextStyle(color: Colors.white)), // ✅ fixed
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    var image = Get.arguments != null
        ? Get.arguments['image']
        : 'assets/images/icon.png';
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.13,
            ),
            CircleAvatar(
              backgroundColor: Get.isDarkMode
                  ? ThemeColor().mode2Sec
                  : ThemeColor().mode1Sec,
              radius: 50,
              backgroundImage: AssetImage('$image'),
            ),
            SizedBox(height: 15),
            Text(
              username,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                  fontSize: 16, color: isDark ? Colors.grey[400] : Colors.grey),
            ),
            SizedBox(height: 40),
            SizedBox(
              height: Get.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      width: Get.width * 0.9,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black45 : Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Divider(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300]),
                          ListTile(
                            leading: Icon(Icons.person,
                                color:
                                    isDark ? Colors.greenAccent : Colors.green),
                            title: Text(
                              'name'.tr,
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(username,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black)),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16,
                                    color:
                                        isDark ? Colors.white70 : Colors.black),
                              ],
                            ),
                            onTap: _editUsername,
                          ),
                          Divider(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300]),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20),
                    child: ElevatedButton(
                      onPressed: _authController.logoutFun,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('logout'.tr,
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
