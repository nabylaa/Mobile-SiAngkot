import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StudentController extends GetxController {
  var imageFile = Rx<File?>(null);

  var nameTemp = "".obs;
  var pictTemp = "".obs;
  var nisnTemp = "".obs;
  var schoolTemp = "".obs;
  var schoolAddressTemp = "".obs;
  var addressTemp = "".obs;
  var phoneTemp = "".obs;
  var emailTemp = "".obs;

  @override
  void dispose() {
    super.dispose();
    imageFile.value = null;
  }

  void setDataInfo(String name, String pict, String address, String phone,
      String email, String nisn, String school, String schoolAddress) {
    nameTemp.value = name;
    addressTemp.value = address;
    pictTemp.value = pict;
    phoneTemp.value = phone;
    emailTemp.value = email;
    nisnTemp.value = nisn;
    schoolTemp.value = school;
    schoolAddressTemp.value = schoolAddress;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }
}
