import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/controller/parent_controller.dart';
import 'package:si_angkot/presentation/widgets/gradient_header.dart';
import 'package:si_angkot/presentation/widgets/logout_dialog_confirmation.dart';
import 'package:si_angkot/presentation/widgets/menu_button.dart';
import 'package:si_angkot/presentation/widgets/student_list_item.dart';

class ParentHomeScreen extends StatelessWidget {
  ParentHomeScreen({super.key});
  final ParentController controller = Get.put(ParentController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientHeader(
              name: authController.currentUser?.name ?? 'Guest',
              subtitle: 'Monitoring anak mu sedang dimana',
              imageUrl: authController.currentUser?.picture ??
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    icon: MyAssets.svg.settings.svg(
                        width: 50,
                        height: 50,
                        colorFilter: ColorFilter.mode(
                            MyColors.primaryColor, BlendMode.srcIn)),
                    label: Constant.SETTING_PROFILE,
                    onTap: () => Get.toNamed(AppRoutes.parentSetting),
                  ),
                  SizedBox(width: 20),
                  MenuButton(
                    icon: MyAssets.svg.userPlus.svg(
                        width: 50,
                        height: 50,
                        colorFilter: ColorFilter.mode(
                            MyColors.primaryColor, BlendMode.srcIn)),
                    label: Constant.FORM_REGISTER,
                    onTap: () => Get.toNamed(AppRoutes.parentFormRegister),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                Constant.PROFILE_STUDENT,
                style: AppTextStyle.textXLPoppins.copyWith(
                    color: MyColors.fontColorPrimary,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () {
                    final linkedStudents = authController.linkedStudents;
                    if (authController.linkedStudents.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          // Memuat ulang data siswa secara manual dengan memanggil listener lagi
                          authController.fetchLinkedStudents();
                          // Tambahkan delay kecil agar refresh indicator terlihat
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(
                                height: 200), // Memberikan ruang untuk scroll
                            Center(
                                child:
                                    Text("Belum ada student yang terdaftar")),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        // Panggil fungsi untuk memuat ulang data siswa
                        await authController.fetchLinkedStudents();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        physics:
                            const AlwaysScrollableScrollPhysics(), // Memastikan scroll berfungsi meski konten sedikit
                        itemCount: linkedStudents.length,
                        itemBuilder: (context, index) {
                          final student = linkedStudents[index];

                          // Menggunakan data dari model
                          return StudentListItem(
                            name: student.name,
                            school: student.school ?? 'Unknown School',
                            status: student.isVerify ?? false,
                            profileImageUrl: student.picture,
                            onTap: () async {
                              // Navigasi ke halaman detail student atau tindakan lainnya
                              if (student.isVerify == false) {
                                AppUtils.showSnackbar(
                                    "Error", "Akun belum diverifikasi",
                                    isError: true);
                              } else {
                                await controller.listenToTrackingId(
                                    student.userId, student);
                                print(
                                    "Tracking: Student ID is s${student.userId}");
                              }
                              // Get.toNamed(AppRoutes.studentDetail, arguments: student);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
