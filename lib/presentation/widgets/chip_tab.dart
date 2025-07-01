import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/tab_controller.dart';

class ChipTab extends StatelessWidget {
  final List<String> tabs;

  const ChipTab({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final TabControllerX tabController = Get.find<TabControllerX>();

    return Obx(() => Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: MyColors.backgroundTabChips,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              for (int i = 0; i < tabs.length; i++)
                _buildTabItem(tabs[i], i, tabController),
            ],
          ),
        ));
  }

  Widget _buildTabItem(String title, int index, TabControllerX tabController) {
    return Expanded(
      child: GestureDetector(
        onTap: () => tabController.selectedTab.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tabController.selectedTab.value == index
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            title,
            style: AppTextStyle.textBASEPoppins.copyWith(
              fontWeight: FontWeight.w600,
              color: tabController.selectedTab.value == index
                  ? MyColors.fontColorPrimary
                  : MyColors.fontColorSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
// use this widget like this
// ChipTabBar(
//   tabs: ["Tab 1", "Tab 2", "Tab 3"],
//   onTabSelected: (index) {
//     print("Tab terpilih: $index");
//   },
// )
