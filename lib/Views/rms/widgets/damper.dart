import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Damper extends StatefulWidget {
  final RxBool isActive;
  final RxBool season;
  final RxDouble temp;
  final RxDouble cfm;

  const Damper({
    super.key,
    required this.isActive,
    required this.season,
    required this.temp,
    required this.cfm,
  });

  @override
  State<Damper> createState() => _DamperState();
}

bool shutter = false;

class _DamperState extends State<Damper> {
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
                  Image.asset("assets/images/damper.png",
                      width: 50, height: 50),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "DAMPER",
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
                        color: widget.isActive.value
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          widget.isActive.value ? "OPEN" : "CLOSE",
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
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.season.value
                            ? Icon(Icons.ac_unit, color: Colors.blue, size: 20)
                            : Icon(Icons.sunny, color: Colors.orange, size: 20),
                        SizedBox(width: 3),
                        Container(
                          height: 15,
                          width: 30,
                          decoration: BoxDecoration(
                            color: widget.season.value
                                ? Colors.lightBlueAccent
                                : Colors.yellow,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              widget.season.value ? "WINTER" : "SUMMER",
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
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.thermostat_outlined,
                            color: Colors.green, size: 25),
                        Center(
                          child: Text(
                            "${widget.temp.value.toStringAsFixed(1)}°C",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "CFM",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Center(
                          child: Text(
                            "${widget.cfm.value.toStringAsFixed(0)}%",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
