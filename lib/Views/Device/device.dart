import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/Views/Device/customWidget/am1Card.dart';
import 'package:testappbita/Views/Device/customWidget/am2444Card.dart';
import 'package:testappbita/Views/Device/customWidget/am2Card.dart';
import 'package:testappbita/Views/Device/customWidget/am1444Card.dart';
import 'package:testappbita/Views/Device/customWidget/aquaCard.dart';
import 'package:testappbita/Views/Device/customWidget/cmCard.dart';
import 'package:testappbita/Views/Device/customWidget/csmCard.dart';
import 'package:testappbita/Views/Device/customWidget/dmCard.dart';
import 'package:testappbita/Views/Device/customWidget/drainCard.dart';
import 'package:testappbita/Views/Device/customWidget/dxCard.dart';
import 'package:testappbita/Views/Device/customWidget/dxMiniCard.dart';
import 'package:testappbita/Views/Device/customWidget/greenHouseCard.dart';
import 'package:testappbita/Views/Device/customWidget/rcmCard.dart';
import 'package:testappbita/Views/Device/customWidget/rmsCard.dart';
import 'package:testappbita/Views/Device/customWidget/sewerageCard.dart';
import 'package:testappbita/Views/Device/customWidget/spCard.dart';
import 'package:testappbita/Views/Device/customWidget/telecome_card.dart';
import 'package:testappbita/Views/Device/customWidget/wtcCard.dart';
import 'package:testappbita/Views/Device/customWidget/zonemasterCard.dart';
import 'package:testappbita/Views/qr_code/qr_code_scanner_page.dart';
import 'package:testappbita/Views/weather/weather_cards.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'package:testappbita/model/user_device_model.dart';
import 'package:testappbita/services/firebase_service.dart';
import 'package:testappbita/utils/theme/theme.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  DevicesPageState createState() => DevicesPageState();
}

class DevicesPageState extends State<DevicesPage> {
  List<DeviceModel> allDeviceData = [];
  final MqttController _mqttcontroller = Get.put(MqttController());

  @override
  void initState() {
    super.initState();
    getTaskListener();
  }

  void getTaskListener() {
    SharedPreferencesService().listenToUserDevices().listen((allTask) {
      debugPrint('Received Data: \$allTask');
      setState(() {
        allDeviceData = allTask;
      });
    }, onError: (error) {
      debugPrint('Error in Listener: \$error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    int crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
    double aspectRatio = orientation == Orientation.portrait ? 1.1 : 1.3;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'home_pages'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade100,
          iconTheme:
              IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
          actions: [
            _mqttcontroller.isConnected.value
                ? CustomIconButton(
                    nextcolor: ThemeColor().actual,
                    backgroundcolor1: Colors.grey.withOpacity(0.2),
                    color: ThemeColor().actual,
                    icon: Icons.cell_tower,
                    onPressed: () {},
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomIconButton(
                        nextcolor: Colors.grey,
                        backgroundcolor1: Colors.grey.withOpacity(0.2),
                        color: Colors.grey,
                        icon: Icons.cell_tower,
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Icon(Icons.cancel, size: 16, color: Colors.red),
                      ),
                    ],
                  ),
            SizedBox(width: 10),
            CustomIconButton(
              nextcolor: ThemeColor().actual,
              backgroundcolor1: Colors.grey.withOpacity(0.2),
              color: ThemeColor().actual,
              icon: Icons.add,
              onPressed: () => Get.to(() => QRCodeScanner()),
            ),
            SizedBox(width: 15),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              WeatherCard(),
              Expanded(
                child: allDeviceData.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: mediaQuery.size.height * 0.2),
                          child: Text(
                            'No Device Found',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: allDeviceData.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 10,
                            childAspectRatio: aspectRatio,
                          ),
                          itemBuilder: (context, index) {
                            final device = allDeviceData[index];
                            final id = device.deviceId?.toUpperCase() ?? "";
                            if (id.startsWith("AM2-A")) {
                              return Am2card(device: device);
                            } else if (id.startsWith("AM2-4")) {
                              return Am2444card(device: device);
                            } else if (id.startsWith("AM1-A")) {
                              return Am1card(device: device);
                            } else if (id.startsWith("AM1-4")) {
                              return Am1444card(
                                device: device,
                                id: "444",
                              );
                            } else if (id.startsWith("AM1-7")) {
                              return Am1444card(device: device, id: "75");
                            } else if (id.startsWith("CM1-")) {
                              return Cmcard(device: device);
                            } else if (id.startsWith("AQM-")) {
                              return Aquacard(device: device);
                            } else if (id.startsWith("DX-")) {
                              return Dxcard(device: device);
                            } else if (id.startsWith("ZMB-")) {
                              return Zonemastercard(device: device);
                            } else if (id.startsWith("TEL-")) {
                              return TelecomeCard(device: device);
                            } else if (id.startsWith("WTC-")) {
                              return Wtccard(device: device);
                            } else if (id.startsWith("DM1-")) {
                              return Draincard(device: device);
                            } else if (id.startsWith("SP1-")) {
                              return Spcard(device: device);
                            } else if (id.startsWith("SM1-")) {
                              return Seweragecard(device: device);
                            } else if (id.startsWith("GHS-")) {
                              return Greenhousecard(device: device);
                            } else if (id.startsWith("DXM-")) {
                              return Dxminicard(device: device);
                            } else if (id.startsWith("RCM-")) {
                              return Rcmastercard(device: device);
                            } else if (id.startsWith("CSM-")) {
                              return Csmcard(device: device);
                            } else if (id.startsWith("RMS-")) {
                              return Rmscard(device: device);
                            } else if (id.startsWith("DM-")) {
                              return Dmcard(device: device);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color nextcolor;
  final Color backgroundcolor1;
  const CustomIconButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.color,
      required this.backgroundcolor1,
      required this.nextcolor});
  @override
  CustomIconButtonState createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton> {
  bool isPressed = false;
  bool isYellow = false;
  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return false;
      setState(() => isYellow = !isYellow);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() => isPressed = false);
          });
          widget.onPressed();
        },
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isYellow
                ? widget.backgroundcolor1
                : Colors.grey.withOpacity(0.2),
          ),
          child: Icon(widget.icon,
              color: isYellow ? widget.color : widget.nextcolor),
        ));
  }
}
