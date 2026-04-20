import 'package:get/get.dart';
import 'package:testappbita/controller/mqtt_controller/mqtt_controller.dart';

class SensorSwitchController extends GetxController {
  final selectedParams = List<String?>.filled(4, null).obs;
  final offsets = List<int>.filled(4, 0).obs;
  final offsetsdm = List<int>.filled(6, 0).obs;
  final offsetsam1 = List<double>.filled(4, 0.0).obs;
  final offsetsam2 = List<double>.filled(4, 0.0).obs;

  void changeOffset(int sensorIndex, double change) {
    final mqtt = Get.find<MqttController>();

    double newValue = offsetsam2[sensorIndex] + change;
    if (newValue >= -10.0 && newValue <= 10.0) {
      newValue = double.parse(newValue.toStringAsFixed(1));
      offsetsam2[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.offsett1.value = newValue.toString();
          break;
        case 1:
          mqtt.offsett2.value = newValue.toString();
          break;
        case 2:
          mqtt.offsett3.value = newValue.toString();
          break;
        case 3:
          mqtt.offsett4.value = newValue.toString();
          break;
      }
    }
  }

  void changeOffsetAm1(int sensorIndex, double change) {
    final mqtt = Get.find<MqttController>();

    double newValue = offsetsam1[sensorIndex] + change;
    if (newValue >= -10.0 && newValue <= 10.0) {
      newValue = double.parse(newValue.toStringAsFixed(1));
      offsetsam1[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.offsett1Am1.value = newValue.toStringAsFixed(1);
          break;
        case 1:
          mqtt.offsett2Am1.value = newValue.toStringAsFixed(1);
          break;
        case 2:
          mqtt.offsett3Am1.value = newValue.toStringAsFixed(1);
          break;
        case 3:
          mqtt.offsett4Am1.value = newValue.toStringAsFixed(1);
          break;
      }
    }
  }

  void dXMasterchangeOffsetA(int sensorIndex, int change) {
    final mqtt = Get.find<MqttController>();

    final newValue = offsetsdm[sensorIndex] + change;
    if (newValue >= -10 && newValue <= 10) {
      offsetsdm[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.offsett1A.value = newValue.toString();
          break;
        case 1:
          mqtt.offsett2A.value = newValue.toString();
          break;
        case 2:
          mqtt.offsett3A.value = newValue.toString();
          break;
        case 3:
          mqtt.offsett4A.value = newValue.toString();
          break;
        case 4:
          mqtt.offsett5.value = newValue.toString();
          break;
        case 5:
          mqtt.offsett6.value = newValue.toString();
          break;
      }
    }
  }

  void dXMasterchangeOffsetB(int sensorIndex, int change) {
    final mqtt = Get.find<MqttController>();

    final newValue = offsetsdm[sensorIndex] + change;
    if (newValue >= -10 && newValue <= 10) {
      offsetsdm[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.offsett1B.value = newValue.toString();
          break;
        case 1:
          mqtt.offsett2B.value = newValue.toString();
          break;
        case 2:
          mqtt.offsett3B.value = newValue.toString();
          break;
        case 3:
          mqtt.offsett4B.value = newValue.toString();
          break;
      }
    }
  }

  void dXchangeOffset(int sensorIndex, int change) {
    final mqtt = Get.find<MqttController>();

    final newValue = offsets[sensorIndex] + change;
    if (newValue >= -10 && newValue <= 10) {
      offsets[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.dxoffsett1.value = newValue.toString();
          break;
        case 1:
          mqtt.dxoffsett2.value = newValue.toString();
          break;
        case 2:
          mqtt.dxoffsett3.value = newValue.toString();
          break;
        case 3:
          mqtt.dxoffsett4.value = newValue.toString();
          break;
      }
    }
  }

  void dXMchangeOffset(int sensorIndex, int change) {
    final mqtt = Get.find<MqttController>();

    final newValue = offsets[sensorIndex] + change;
    if (newValue >= -10 && newValue <= 10) {
      offsets[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.dxmoffsett1.value = newValue.toString();
          break;
        case 1:
          mqtt.dxmoffsett2.value = newValue.toString();
          break;
        case 2:
          mqtt.dxmoffsett3.value = newValue.toString();
          break;
      }
    }
  }

  void changeOffsetAQM(int sensorIndex, int change) {
    final mqtt = Get.find<MqttController>();

    final newValue = offsets[sensorIndex] + change;
    if (newValue >= -10 && newValue <= 10) {
      offsets[sensorIndex] = newValue;

      switch (sensorIndex) {
        case 0:
          mqtt.offset1Aqua.value = newValue.toString();
          break;
        case 1:
          mqtt.offset2Aqua.value = newValue.toString();
          break;
      }
    }
  }
}
