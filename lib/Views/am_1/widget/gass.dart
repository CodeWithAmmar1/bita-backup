import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'dart:developer';

void showGasSelector(BuildContext context) {
  final MqttController mqttController = Get.find<MqttController>();
  final gases = ['R-22', 'R-32', 'R-407C', 'R-410A'];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: true,
    builder: (_) {
      return Obx(() => Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('select_gas'.tr, style: TextStyle(fontSize: 18)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                Divider(),
                ...List.generate(gases.length, (index) {
                  return ListTile(
                    title: Text(gases[index]),
                    trailing: mqttController.gastype.value == index
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      mqttController.gastype.value = index;
                      mqttController.gasestype(index.toString());
                      log('Selected gas index: ${mqttController.gastype.value}');
                      // Navigator.of(context).pop();
                    },
                  );
                }),
              ],
            ),
          ));
    },
  );
}
