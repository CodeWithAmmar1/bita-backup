import 'package:get/get.dart';

class CardController extends GetxController {
  var isTapped = false.obs;
  void onTap() {
    isTapped.value = true;
    Get.defaultDialog(
      title: "Confirm",
      middleText: "Do you want to perform the action?",
      onConfirm: () {
        Get.back();
        isTapped.value = false;
      },
      onCancel: () {
        Get.back();
        isTapped.value = false;
      },
    );
  }
}
