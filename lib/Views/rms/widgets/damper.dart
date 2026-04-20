import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Damper extends StatefulWidget {
  const Damper({super.key});

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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        shutter = !shutter;
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: shutter ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          shutter ? "OPEN" : "CLOSE",
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
                      shutter
                          ? Icon(Icons.sunny, color: Colors.orange, size: 20)
                          : Icon(Icons.ac_unit, color: Colors.blue, size: 20),
                      SizedBox(width: 3),
                      Container(
                        height: 15,
                        width: 30,
                        decoration: BoxDecoration(
                          color:
                              shutter ? Colors.yellow : Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            shutter ? "SUMMER" : "WINTER",
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
                          "45%",
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
