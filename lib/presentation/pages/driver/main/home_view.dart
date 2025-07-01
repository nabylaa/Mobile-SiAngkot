import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/controller/driver_controller.dart';
import 'package:si_angkot/presentation/widgets/gradient_header.dart';
import 'package:si_angkot/presentation/widgets/logout_dialog_confirmation.dart';
import 'package:si_angkot/presentation/widgets/route_item.dart';
import 'package:si_angkot/presentation/widgets/start_journey_dialog.dart';

class DriverHomeView extends StatelessWidget {
  DriverHomeView({super.key});
  final DriverController driverController = Get.put(DriverController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dutyCard(),
                    const SizedBox(height: 16),
                    _buildRouteSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      return Column(
        children: [
          GradientHeader(
            name: authController.currentUser?.name ?? 'Guest',
            subtitle: 'Selamat bekerja',
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
            onSignOut: () {
              LogoutDialogConfirmation.show(
                onSignOut: () {
                  authController.logout();
                  // AppUtils.showSnackbar("Logout", "Berhasil Logout");
                },
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildRouteSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rute Perjalanan",
            style: AppTextStyle.textHeadingPoppins.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => _buildRouteList()),
        ],
      ),
    );
  }

  // Extract the route list to its own method for better organization
  Widget _buildRouteList() {
    var routes = driverController.addressList;
    if (routes.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada rute dipilih",
          style: TextStyle(color: MyColors.primaryColor),
        ),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 15), // Remove default padding
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final isLast = index == routes.length - 1;
        return RouteListItem(
          routeName: routes[index],
          isLast: isLast,
        );
      },
    );
  }

  Widget dutyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status",
              style: AppTextStyle.textBASEPoppins.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: MyColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.circle,
                    color: driverController.dutyType.value == "OnDuty"
                        ? Colors.green
                        : Colors.grey,
                    size: 12),
                const SizedBox(width: 8),
                Text(
                  driverController.deliveryType.value.isNotEmpty
                      ? driverController.deliveryType.value
                      : "Tidak ada",
                  style: AppTextStyle.textBASEPoppins.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: driverController.dutyType.value == "OnDuty"
                        ? MyColors.fontColorPrimary
                        : MyColors.fontColorSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Rute",
              style: AppTextStyle.textBASEPoppins.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: MyColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.circle,
                    color: driverController.dutyType.value == "OnDuty"
                        ? Colors.green
                        : Colors.grey,
                    size: 12),
                const SizedBox(width: 8),
                Text(
                  driverController.selectedRoute.value.isNotEmpty
                      ? driverController.selectedRoute.value
                      : "Tidak ada rute",
                  style: AppTextStyle.textBASEPoppins.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: driverController.dutyType.value == "OnDuty"
                        ? MyColors.fontColorPrimary
                        : MyColors.fontColorSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C7A1),
                  foregroundColor: const Color(0xFFE26C2C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  if (driverController.dutyType.value == "OnDuty") {
                    final studentIdsCopy =
                        List<String>.from(driverController.studentIds);
                    driverController.dutyType.value = "OffDuty";
                    driverController.addressList.clear();
                    driverController.deliveryType.value = "";
                    driverController.selectedRoute.value = "";
                    SharedPreferencesHelper.putString(
                        Constant.TRACKING_ID_KEY, "");
                    driverController.trackingService.stopLocationUpdates();
                    for (var studentId in studentIdsCopy) {
                      driverController.removeTrackingIdStudent(
                        studentId: studentId,
                        onResult: (isSuccess, message) {
                          if (isSuccess) {
                            print("Location: success remove $studentId");
                            driverController.studentIds.remove(studentId);
                          } else {
                            print(
                                "Failed to remove tracking ID for $studentId");
                          }
                        },
                      );
                    }
                  } else {
                    bool isGranted =
                        await handleLocationPermission(Get.context!);
                    if (!isGranted) return;
                    showDialog(
                        context: Get.context!,
                        builder: (_) => StartJourneyDialog());
                  }
                },
                child: Text(
                  driverController.dutyType.value == "OnDuty"
                      ? "Stop Perjalanan"
                      : "Mulai Perjalanan",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah service lokasi nyala
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppUtils.showSnackbar(
          "Layanan lokasi tidak aktif", "Silakan aktifkan GPS",
          isError: true);
      return false;
    }

    // Cek status permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppUtils.showSnackbar(
            "Izin lokasi ditolak", "Silakan izinkan akses lokasi",
            isError: true);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppUtils.showSnackbar("Izin lokasi ditolak",
          "Silakan izinkan akses lokasi di pengaturan aplikasi",
          isError: true);
      return false;
    }

    return true;
  }
}
