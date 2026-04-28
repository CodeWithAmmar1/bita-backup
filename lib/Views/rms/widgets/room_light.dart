import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Roomlight extends StatefulWidget {
  final String title;
  final RxInt isActive;
  final RxDouble brightness;
  const Roomlight(
      {super.key,
      required this.title,
      required this.isActive,
      required this.brightness});

  @override
  State<Roomlight> createState() => _RoomlightState();
}

class _RoomlightState extends State<Roomlight> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: Get.height * 0.16,
        width: Get.width * 0.45,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(60),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode ? Colors.white : Colors.black,
                        BlendMode.srcIn),
                    child: Image.asset("assets/images/bulb.png",
                        width: 50, height: 50),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Obx(
                    () => Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: widget.isActive.value == 1
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          widget.isActive.value == 1 ? "ON" : "OFF",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.model_training_rounded,
                          color: Colors.yellowAccent, size: 25),
                      SizedBox(width: 5),
                      Obx(
                        () => Text(
                          "${widget.brightness.value.toStringAsFixed(0)}%",
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
