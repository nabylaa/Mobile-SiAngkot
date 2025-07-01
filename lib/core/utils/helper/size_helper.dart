import 'package:get/get.dart';

class SizeHelper {
  static double dynamicHeight(double height) {
    return Get.height *
        (height / Get.height); // Menyesuaikan dengan tinggi layar perangkat
  }

  static double dynamicWidth(double width) {
    return Get.width *
        (width / Get.width); // Menyesuaikan dengan lebar layar perangkat
  }
}
