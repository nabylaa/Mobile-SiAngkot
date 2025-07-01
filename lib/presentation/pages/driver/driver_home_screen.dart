import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/driver_controller.dart';
import 'package:si_angkot/presentation/pages/driver/main/history_view.dart';
import 'package:si_angkot/presentation/pages/driver/main/home_view.dart';
import 'package:si_angkot/presentation/pages/driver/main/settings_view.dart';
import 'package:si_angkot/presentation/widgets/custom_bottom_navigation_item.dart';

class DriverHomeScreen extends StatelessWidget {
  DriverHomeScreen({super.key});
  final DriverController driverController = Get.put(DriverController());

  final List<Widget> pages = [
    DriverHomeView(),
    DriverHistoryView(),
    DriverSettingsView()
  ];

  int _getBottomNavIndex(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return 0;
      case 1:
        return 2;
      case 2:
        return 3;
      default:
        return 0;
    }
  }

  Future<void> _checkTrackingIdAndNavigate(int index) async {
    final trackingId =
        SharedPreferencesHelper.getString(Constant.TRACKING_ID_KEY);

    // Check if trackingId is null or empty
    if (trackingId == null || trackingId.isEmpty) {
      // Show Snackbar
      AppUtils.showSnackbar(
          "Oops!", "Mulai tugas anda terlebih dahulu, baru bisa scan QR",
          isError: true);
      // Prevent navigation to Scan QR page
      return;
    }
    // Proceed to selected page if trackingId is valid
    driverController.selectBottomNav(index);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: pages[driverController.bottomNavIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex:
              _getBottomNavIndex(driverController.bottomNavIndex.value),
          onTap: (index) {
            if (index == 1) {
              // Check if trackingId is valid before navigating to Scan QR page
              _checkTrackingIdAndNavigate(index);
            } else {
              driverController.selectBottomNav(index);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColors.primaryColor,
          unselectedItemColor: MyColors.bottomNavFontColorUnselected,
          selectedLabelStyle: AppTextStyle.textHeadingLGPoppins.copyWith(
              color: MyColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 12),
          unselectedLabelStyle: AppTextStyle.textHeadingLGPoppins.copyWith(
              color: MyColors.bottomNavFontColorUnselected,
              fontWeight: FontWeight.w600,
              fontSize: 12),
          iconSize: 24,
          selectedIconTheme: IconThemeData(color: MyColors.primaryColor),
          unselectedIconTheme:
              IconThemeData(color: MyColors.bottomNavIconColorUnselected),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: CustomBottomNavigationItem(
                icon: HugeIcons.strokeRoundedHome11,
                label: Constant.HOME,
                isSelected:
                    _getBottomNavIndex(driverController.bottomNavIndex.value) ==
                        0,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavigationItem(
                icon: HugeIcons.strokeRoundedCenterFocus,
                label: Constant.SCAN_QR,
                isSelected: false,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavigationItem(
                icon: HugeIcons.strokeRoundedClock02,
                label: Constant.HISTORY_EN,
                isSelected:
                    _getBottomNavIndex(driverController.bottomNavIndex.value) ==
                        2,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: CustomBottomNavigationItem(
                icon: HugeIcons.strokeRoundedSetting07,
                label: Constant.SETTING,
                isSelected:
                    _getBottomNavIndex(driverController.bottomNavIndex.value) ==
                        3,
              ),
              label: "",
            ),
          ],
        ),
      );
    });
  }
}
