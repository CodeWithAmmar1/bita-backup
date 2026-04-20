import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';

class Watertankdrain extends StatefulWidget {
  const Watertankdrain({super.key});

  @override
  WaterTankState createState() => WaterTankState();
}

class WaterTankState extends State<Watertankdrain>
    with TickerProviderStateMixin {
  late AnimationController _waterLevelController;
  late Animation<double> _waterLevelAnimation;
  final MqttController mqttController = Get.put(MqttController());
  late AnimationController _flowController;
  bool showFlow = false;
  bool showOverWater = false;

  double get baseWaterLevel {
    switch (mqttController.level.value) {
      case 0:
        return 0.05;
      case 1:
        return 0.40;
      case 2:
        return 0.70;
      default:
        return 0.5;
    }
  }

  double get overWaterLevel {
    switch (mqttController.level.value) {
      case 2:
        return 0.70;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _flowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..repeat();

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

  void checkOverWaterLevel() {
    if (mqttController.level.value == 2 && !showOverWater) {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) setState(() => showOverWater = true);
      });
    } else if (mqttController.level.value != 2 && showOverWater) {
      showOverWater = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double animatedWaterLevel = baseWaterLevel + _waterLevelAnimation.value;
      double animatedWaterLevelOver =
          showOverWater ? overWaterLevel + _waterLevelAnimation.value : 0;

      checkOverWaterLevel();

      return Stack(
        children: [
          Positioned(
            right: 75,
            child: Container(
              width: 170,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black26, width: 2),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 95 * animatedWaterLevel,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: 135,
            child: Container(
              height: 12,
              width: 37,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(2),
                    topRight: Radius.circular(2)),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 9 * animatedWaterLevelOver,
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 30,
            child: Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black26, width: 2),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 50 * animatedWaterLevelOver,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (mqttController.level.value == 2 && !showFlow) {
              Future.delayed(Duration(seconds: 1), () {
                if (mounted) setState(() => showFlow = true);
              });
            } else if (mqttController.level.value != 2 && showFlow) {
              showFlow = false;
            }

            return Stack(
              children: [
                if (showFlow)
                  Positioned(
                    right: 15,
                    bottom: 105,
                    child: _buildFlowPipe(),
                  ),
              ],
            );
          }),
        ],
      );
    });
  }

  Widget _buildFlowPipe() {
    return Transform.rotate(
      angle: 90 * 3.1415926535 / 180,
      child: SizedBox(
        width: 50,
        height: 30,
        child: AnimatedBuilder(
          animation: _flowController,
          builder: (_, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                double position = (i / 4);
                double anim = (_flowController.value - position);
                if (anim < 0) anim += 1;

                return Transform.translate(
                  offset: Offset(anim * 50, 0),
                  child: Container(
                    width: 10,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _waterLevelController.dispose();
    _flowController.dispose();
    super.dispose();
  }
}
