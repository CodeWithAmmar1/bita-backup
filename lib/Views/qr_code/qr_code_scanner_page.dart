import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/services/firebase_service.dart';
import 'package:testappbita/utils/button/button.dart';
import 'package:testappbita/utils/theme/theme.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner>
    with SingleTickerProviderStateMixin {
  bool isScanning = true;
  MobileScannerController cameraController = MobileScannerController();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isConnectedToDevice = false;
  bool isLoading = false;
  bool isDialogOpen = true;
  final apiUrl = Uri.parse('http://192.168.4.1/wifi_param_by_app');
  String wificheck = "";
  bool showIndicator = true;
  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) {
      setState(() {
        cameraController = MobileScannerController();
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.location.request();
  }

  Future<void> sendWifiCredentials(
      String ssid, String password, String dssid, String dpassword) async {
    var response = await http.post(apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"ssid": ssid, "password": password}));
    print(
        "checkingissue 2063| response body= ${response.body} response code = ${response.statusCode}");
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        if (responseData['wifi_status'] == 1) {
          WiFiForIoTPlugin.getSSID()
              .then((val) => WiFiForIoTPlugin.removeWifiNetwork(val!));
          WiFiForIoTPlugin.disconnect();
          WiFiForIoTPlugin.forceWifiUsage(false);
          log('ESP32 successfully configured.');
          log(responseData.toString());
          await _showdevicenameDialog(dssid, dpassword);
        }
        if (responseData['wifi_status'] == 0) {
          await _showWifiErrorDialog(dssid, dpassword);
        }
      } else {
        log('Error: ${response.body}');
      }
    } else {
      log('Failed with status code: ${response.statusCode} ISUEEEEEEEEEE______-');
    }
  }

  Future<void> diconnectwifi() async {
    final disconnectedd = await WiFiForIoTPlugin.disconnect();
    if (disconnectedd) {
      log("Disconnected");
    } else {
      log("Not Disconnected");
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty && isScanning) {
      final String? code = capture.barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          isScanning = false;
          cameraController.stop();
          isDialogOpen = false;
        });
        _parseQRCode(code);
      }
    }
  }

  Future<void> _parseQRCode(String code) async {
    print("Scanned QR Code: $code");

    final wifiRegex = RegExp(
      r'WIFI:T:[^;]*;S:(?<ssid>[^;]*);P:(?<password>[^;]*);(?:H:(?:true|false|);)?',
      caseSensitive: false,
    );

    final wifiMatch = wifiRegex.firstMatch(code);

    if (wifiMatch != null) {
      final ssid = wifiMatch.namedGroup('ssid');
      final password = wifiMatch.namedGroup('password');
      if (ssid?.isNotEmpty == true && password?.isNotEmpty == true) {
        _connectToWiFi(ssid!, password!);
      } else {
        print("SSID or Password is null or empty.");
      }
    } else {
      print("No match for Wi-Fi QR code.");
    }
  }

  Future<void> _connectToWiFi(String ssid, String password) async {
    bool isConnected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      isHidden: true,
      joinOnce: true,
      withInternet: false,
    );

    if (isConnectedToDevice == false) {
      if (isConnected) {
        isConnectedToDevice = true;
        log("Connected to ${ssid}");
        await _showWiFiDialog(ssid, password);
        await WiFiForIoTPlugin.forceWifiUsage(true);
      } else {
        _showErrorDialog(context);
      }
    }
  }

  void _showErrorDialog(BuildContext context) async {
    setState(() {
      isScanning = false;
    });
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Error',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'There was an error scanning the code. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isScanning = true;
                });
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  var pass = true;
  Future<void> _showWiFiDialog(String hwSsid, String hwPassword) async {
    TextEditingController passwordController = TextEditingController();
    TextEditingController manualSsidController = TextEditingController();

    String? selectedSSID;
    List<WifiNetwork?> wifiList = [];
    bool isPasswordVisible = false;
    bool manualMode = false;

    await WiFiForIoTPlugin.loadWifiList().then((value) {
      wifiList = value;
    });

    String? currentSSID = await WiFiForIoTPlugin.getSSID();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text('Connect Device to Wi-Fi',
                  style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Enter Wi-Fi manually",
                            style: TextStyle(color: Colors.white)),
                        Switch(
                          activeColor: Colors.white,
                          activeTrackColor: Color(0xFF24C48E),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          value: manualMode,
                          onChanged: (val) {
                            setState(() {
                              manualMode = val;
                            });
                          },
                        ),
                      ],
                    ),
                    if (manualMode) ...[
                      TextField(
                        controller: manualSsidController,
                        cursorColor: Colors.tealAccent,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Wi-Fi Name (SSID)",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ] else ...[
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        hint: Text("Select Wi-Fi",
                            style: TextStyle(color: Colors.white)),
                        value: selectedSSID,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSSID = newValue;

                            if (currentSSID == newValue) {
                              passwordController.text = hwPassword;
                            } else {
                              passwordController.clear();
                            }
                          });
                        },
                        items: wifiList
                            .map((wifi) => wifi?.ssid)
                            .where((ssid) => ssid != null && ssid.isNotEmpty)
                            .map((ssid) {
                          return DropdownMenuItem(
                            value: ssid,
                            child: Text(ssid!,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                    ],
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      cursorColor: Colors.tealAccent,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Button(
                  onTap: () {
                    String finalSSID = manualMode
                        ? manualSsidController.text
                        : selectedSSID ?? "";

                    if (finalSSID.isEmpty) {
                      Get.snackbar(
                          "SSID Required", "Please enter or select Wi-Fi",
                          colorText: Colors.white, backgroundColor: Colors.red);
                      return;
                    }

                    sendWifiCredentials(
                        finalSSID, passwordController.text, hwSsid, hwPassword);
                    Navigator.of(context).pop();
                  },
                  buttonText: 'Send',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showWifiErrorDialog(String dssid, String dpassword) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
              title: Text(
                'Configuration Error',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Device did not connect to internet",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    WiFiForIoTPlugin.getSSID().then(
                        (val) => WiFiForIoTPlugin.removeWifiNetwork(val!));
                    WiFiForIoTPlugin.disconnect();
                    WiFiForIoTPlugin.forceWifiUsage(false);
                    Get.close(2);
                  },
                  child: Text('Close',
                      style: TextStyle(color: ThemeColor().actual)),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    _showWiFiDialog(dssid, dpassword);
                  },
                  child: Text('Try Again',
                      style: TextStyle(color: ThemeColor().actual)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showdevicenameDialog(String ssid, String password) async {
    TextEditingController nameController = TextEditingController();
    bool isDialogLoading = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
              title: Text(
                'Enter Your Device Name',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.tealAccent,
                          ),
                        ),
                        labelText: 'Device Name',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      cursorColor: Colors.tealAccent,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isDialogLoading = true;
                    });

                    final ssidd = nameController.text;
                    final ip = "000.000.000.000";
                    final mac = "00:00:00:00:00:00";
                    String deviceid = ssid;
                    debugPrint("$ip $mac $ssidd $deviceid");
                    await SharedPreferencesService().sendDeviceData(
                      data: DeviceModel(
                        deviceId: deviceid,
                        deviceIp: ip,
                        deviceMac: mac,
                        deviceName: ssidd,
                      ),
                    );
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('deviceId', deviceid);
                    log("${prefs.getString('deviceId')} Device Saved");
                    setState(() {
                      isDialogLoading = false;
                    });
                    Get.close(2);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isDialogLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Send",
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          ClipRRect(
            child: isScanning
                ? MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  )
                : Center(
                    child: isDialogOpen ? SizedBox.shrink() : SizedBox(),
                  ),
          ),
          if (isScanning)
            Positioned(
              top: 18,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: _animation.value * (Get.height * 0.8 - 10)),
                    height: 5,
                    width: double.infinity,
                    color: Colors.redAccent.withValues(alpha: 0.8),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
