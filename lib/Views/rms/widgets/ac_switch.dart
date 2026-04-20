import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcSwitch extends StatefulWidget {
  final RxInt isActive;
  const AcSwitch({super.key, required this.isActive});

  @override
  State<AcSwitch> createState() => _AcSwitchState();
}

class _AcSwitchState extends State<AcSwitch> {
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
                    child: Image.asset("assets/images/ac.png",
                        width: 50, height: 50),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "AC SWITCH",
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
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      widget.isActive.value == 1
                          ? Icon(Icons.sunny, color: Colors.orange, size: 20)
                          : Icon(Icons.ac_unit, color: Colors.blue, size: 20),
                      SizedBox(width: 3),
                      Container(
                        height: 15,
                        width: 30,
                        decoration: BoxDecoration(
                          color: widget.isActive.value == 1
                              ? Colors.yellow
                              : Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            widget.isActive.value == 1 ? "SUMMER" : "WINTER",
                            style: TextStyle(
                              fontSize: 6,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.thermostat_outlined,
                          color: Colors.green, size: 25),
                      Center(
                        child: Text(
                          "36°C",
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Center(
                        child: Text(
                          "CFM",
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Center(
                        child: Text(
                          "20%",
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined,
                          color: Colors.green, size: 25),
                      SizedBox(width: 5),
                      Icon(Icons.settings,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 25),
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
