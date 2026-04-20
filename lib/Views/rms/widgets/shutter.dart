import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Shutter extends StatefulWidget {
  const Shutter({super.key});

  @override
  State<Shutter> createState() => _ShutterState();
}

bool shutter = false;

class _ShutterState extends State<Shutter> {
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
                    child: Image.asset("assets/images/shutter.png",
                        width: 50, height: 50),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "SHUTTER",
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
                  Icon(Icons.settings,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      size: 25),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
