import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/presentation/pages/driver/secondary/input_nisn_view.dart';
import 'package:si_angkot/presentation/pages/driver/secondary/scan_view.dart';

class MainScanView extends GetView<DriverController> {
  MainScanView({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            // Switch content
            controller.currentIndex.value == 0 ? ScanView() : InputNisnView(),

            // Floating custom nav
            Positioned(
              left: 24,
              right: 24,
              bottom: 32,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 50,
                decoration: BoxDecoration(
                  color: MyColors.backgroundTabChips,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildTabButton("Scan Code", 0),
                    _buildTabButton("Enter NISN", 1),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changePage(index),
        child: Obx(() {
          final isActive = controller.currentIndex.value == index;
          return Container(
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: AppTextStyle.textHeadingSMPoppins.copyWith(
                color: isActive
                    ? MyColors.fontColorPrimary
                    : MyColors.fontColorSecondary,
              ),
            ),
          );
        }),
      ),
    );
  }
}
