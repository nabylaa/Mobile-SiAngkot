import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';

class CustomBottomNavigationScanView extends GetView<DriverController> {
  const CustomBottomNavigationScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: MyColors.colorWhite,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem("Scan Code", 0),
          _buildNavItem("Enter NISN", 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return InkWell(
        onTap: () => controller.changePage(index),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: isSelected
              ? BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                )
              : null,
          child: Text(
            title,
            style: AppTextStyle.textBASEPoppins.copyWith(
              fontSize: 14,
              color: isSelected
                  ? MyColors.fontColorPrimary
                  : MyColors.fontColorSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }
}
