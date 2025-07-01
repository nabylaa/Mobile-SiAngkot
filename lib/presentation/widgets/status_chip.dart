import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/driver_controller.dart';

class StatusChip extends StatelessWidget {
  final List<String> listStatus;

  const StatusChip({
    super.key,
    required this.listStatus,
  });

  @override
  Widget build(BuildContext context) {
    final DriverController driverController = Get.find<DriverController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Duty status',
            style: TextStyle(
              color: MyColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (int i = 0; i < listStatus.length; i++)
                _buildStatusButton(listStatus[i], i, driverController),
            ],
          )
        ],
      );
    });
  }

  Widget _buildStatusButton(
      String label, int index, DriverController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => controller.selectedStatusIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: controller.selectedStatusIndex.value == index
                ? MyColors.backgroundSuccess
                : MyColors.backgroundChipDuty,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.selectedStatusIndex.value == index
                  ? MyAssets.svg.checklist.svg(
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                          MyColors.fontColorSuccess, BlendMode.srcIn),
                    )
                  : MyAssets.svg.cross.svg(
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                          MyColors.fontColorPrimary, BlendMode.srcIn),
                    ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyle.textBASEPoppins.copyWith(
                  color: controller.selectedStatusIndex.value == index
                      ? MyColors.fontColorSuccess
                      : MyColors.fontColorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
