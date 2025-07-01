import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';

class LogoutDialogConfirmation extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final Function()? onSignOut;
  LogoutDialogConfirmation({
    this.onSignOut,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Konfirmasi Logout',
          style: AppTextStyle.textHeadingLGPoppins
              .copyWith(color: MyColors.fontColorPrimary)),
      content: Text('Apakah Anda yakin ingin keluar dari aplikasi?',
          style: AppTextStyle.textBASEPoppins.copyWith(
              color: MyColors.fontColorPrimary,
              overflow: TextOverflow.visible,
              fontSize: 14)),
      actions: [
        TextButton(
          onPressed: () {
            // Tutup dialog
            Get.back();
          },
          child: Text(
            'Batal',
            style: AppTextStyle.textBASEPoppins.copyWith(
                color: MyColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Proses logout
            if (onSignOut != null) {
              onSignOut!();
              Get.back();
            } else {
              // Default action if onSignOut is not provided
              print("Sign out action not defined.");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Warna merah untuk tombol logout
          ),
          child: Text(
            'Logout',
            style: AppTextStyle.textBASEPoppins.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Metode untuk menampilkan dialog
  static void show({required Null Function() onSignOut}) {
    Get.dialog(
      LogoutDialogConfirmation(onSignOut: onSignOut),
      barrierDismissible:
          false, // Tidak bisa ditutup dengan menekan area di luar dialog
    );
  }
}
