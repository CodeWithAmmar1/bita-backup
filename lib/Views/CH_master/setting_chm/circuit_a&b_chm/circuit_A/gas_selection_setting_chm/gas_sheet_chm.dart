import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';
import 'dart:developer';

void gasSheetChm(BuildContext context, RxInt gas, bool permissiongas) {
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
                    trailing: gas.value == index
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      gas.value = index;
                      mqttController.gasstypeDm(
                          index.toString(), permissiongas);
                      log('Selected gas index: ${gas.value}');
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
