import 'dart:async';
import 'dart:io';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/data/models/students_model.dart';

import '../../core/app_routes.dart';
import '../../data/remote/tracking_service.dart';

class ParentController extends GetxController {
  final TrackingService _trackingService = TrackingService();

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  final mapController = MapController();
  Timer? recenterTimer;

  var studentsList = <StudentData>[].obs;
  var imageFile = Rx<File?>(null);
  var nameTemp = "".obs;
  var pictTemp = "".obs;
  var addressTemp = "".obs;
  var phoneTemp = "".obs;
  var emailTemp = "".obs;

  final RxInt selectedTabIndex = 0.obs;
  final RxString studentTrackingId = ''.obs;
  StreamSubscription<String?>? _trackingSubscription;

  Future<void> listenToTrackingId(String userId, UserModel student) async {
    _trackingSubscription?.cancel(); // cancel jika ada stream sebelumnya
    _trackingSubscription = _trackingService.streamTrackingId(userId).listen(
      (id) {
        print("Tracking : listent studentTrackingId: $id");
        studentTrackingId.value = id ?? "";
        if (id != null && id.isNotEmpty) {
          startTracking();
          print("MAP READY : Start Tracking");
        } else {
          stopTracking();
          print("MAP READY : stop Tracking");
        }
        Get.toNamed(AppRoutes.parentTracking, arguments: student);
      },
    );
  }

  void stopTrackingStream() {
    _trackingSubscription?.cancel();
    _trackingSubscription = null;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void dispose() {
    imageFile.value = null;
    stopTracking();
    stopTrackingStream();
    recenterTimer?.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    stopTracking();
    stopTrackingStream();
    recenterTimer?.cancel();
    super.onClose();
  }

  void resetDataInfo() {
    nameTemp.value = "";
    addressTemp.value = "";
    pictTemp.value = "";
    phoneTemp.value = "";
    emailTemp.value = "";
  }

  void setDataInfo(
      String name, String pict, String address, String phone, String email) {
    nameTemp.value = name;
    addressTemp.value = address;
    pictTemp.value = pict;
    phoneTemp.value = phone;
    emailTemp.value = email;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  void startTracking() {
    final trackingId = studentTrackingId.value;
    if (trackingId.isEmpty) {
      stopTracking();
      return;
    }

    _trackingService.listenToTracking(
      trackingId: trackingId,
      onLocationUpdate: (lat, long) {
        latitude.value = lat;
        longitude.value = long;
      },
    );
  }

  void stopTracking() {
    _trackingService.stopListening();
  }
}
