import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';

class WtcWaterTank extends StatefulWidget {
  const WtcWaterTank({super.key});

  @override
  WaterTankState createState() => WaterTankState();
}

class WaterTankState extends State<WtcWaterTank>
    with TickerProviderStateMixin {
  late AnimationController _waterLevelController;
  late Animation<double> _waterLevelAnimation;
  final MqttController mqttController = Get.put(MqttController());

  double get baseWaterLevel {
    switch (mqttController.wtcuserSetValue.value) {
      case 0:
        return 0.05; // Low (0%)
      case 1:
        return 0.70; // High (100%)
      default:
        return 0.5; // Default to Mid
    }
  }

  @override
  void initState() {
    super.initState();

    _waterLevelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..repeat(reverse: true);

    _waterLevelAnimation =
        _waterLevelController.drive(Tween(begin: 0.0, end: 0.2))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) { final media = MediaQuery.of(context);
    final isPortrait = media.orientation == Orientation.portrait;
    final baseSize = isPortrait ? media.size.height : media.size.width;
    final shortestSide = media.size.shortestSide;
    return Obx(() {
      double animatedWaterLevel = baseWaterLevel + _waterLevelAnimation.value;

      return Stack(
        children: [
           Positioned(
              right: shortestSide * 0.02,
              child: Container(
                width: shortestSide * 0.14,
                height: baseSize * 0.16,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black26, width: 2),
                ),
                child:Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 150 * animatedWaterLevel,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _waterLevelController.dispose();
    super.dispose();
  }
}
