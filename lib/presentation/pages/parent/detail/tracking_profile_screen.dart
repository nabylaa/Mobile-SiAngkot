import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/presentation/controller/history_controller.dart';

class TrackingProfileScreen extends StatelessWidget {
  TrackingProfileScreen({super.key});
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedStudentHistory.value == null) {
        return Center(
          child: Text(
            'Tidak ada data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            buildItem('Nama Lengkap',
                '${controller.selectedStudentHistory.value?.name}'),
            buildItem(
                'NISN', '${controller.selectedStudentHistory.value?.nisn}'),
            buildItem('Sekolah',
                '${controller.selectedStudentHistory.value?.school}'),
            buildItem('Alamat Sekolah',
                '${controller.selectedStudentHistory.value?.schoolAddress}'),
            buildItem('Nomor HP',
                '${controller.selectedStudentHistory.value?.phone}'),
            buildItem(
                'Email', '${controller.selectedStudentHistory.value?.email}'),
          ],
        ),
      );
    });
  }

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
