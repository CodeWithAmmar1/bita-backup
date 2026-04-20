import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:get/get.dart';

class CarbonMono extends StatelessWidget {
  final RxInt value;
  const CarbonMono({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedRadialGauge(
          duration: const Duration(seconds: 1),
          curve: Curves.elasticOut,
          radius: 40,
          value: value.value.toDouble(),
          axis: GaugeAxis(
              min: 0,
              max: 100,
              degrees: 180,
              style: const GaugeAxisStyle(
                thickness: 15,
                background: Colors.transparent,
                segmentSpacing: 4,
              ),
              pointer: GaugePointer.needle(
                borderRadius: 16,
                width: 10,
                height: 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              progressBar: GaugeProgressBar.rounded(
                color: Colors.transparent,
              ),
              segments: [
                const GaugeSegment(
                  from: 0,
                  to: 25,
                  color: Colors.blueAccent,
                  cornerRadius: Radius.zero,
                ),
                const GaugeSegment(
                  from: 25,
                  to: 50,
                  color: Colors.amberAccent,
                  cornerRadius: Radius.zero,
                ),
                const GaugeSegment(
                  from: 50,
                  to: 75,
                  color: Colors.orange,
                  cornerRadius: Radius.zero,
                ),
                const GaugeSegment(
                  from: 75,
                  to: 100,
                  color: Colors.redAccent,
                  cornerRadius: Radius.zero,
                ),
              ])),
    );
  }
}
