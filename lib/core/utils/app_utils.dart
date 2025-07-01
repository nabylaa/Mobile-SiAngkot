import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';

class AppUtils {
  static void showSnackbar(
    String title,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar(); // Cegah spam snackbar

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  static void showLoading() {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  static String generateTrackingId(String id) {
    final DateTime now = DateTime.now();
    final String formattedDate = "yymmddHHmm".replaceAllMapped(
      RegExp(r'y|m|d|H|M'),
      (match) {
        switch (match[0]) {
          case 'y':
            return now.year.toString().substring(2, 4);
          case 'm':
            return now.month.toString().padLeft(2, '0');
          case 'd':
            return now.day.toString().padLeft(2, '0');
          case 'H':
            return now.hour.toString().padLeft(2, '0');
          case 'M':
            return now.minute.toString().padLeft(2, '0');
          default:
            return '';
        }
      },
    );
    return "$formattedDate$id";
  }

  static void showDialog(
    String title,
    String message, {
    required VoidCallback onConfirm,
    void Function()? onCancel,
    String confirmText = "OK",
    String cancelText = "Cancel",
    int? countdownSeconds,
  }) {
    late Timer? countdownTimer;
    int remainingSeconds = countdownSeconds ?? 0;
    final RxInt timerText = remainingSeconds.obs;

    if (countdownSeconds != null) {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingSeconds <= 1) {
          timer.cancel();
          Get.back();
          onConfirm();
        } else {
          remainingSeconds--;
          timerText.value = remainingSeconds;
        }
      });
    }

    Get.defaultDialog(
      title: title,
      radius: 12,
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (countdownSeconds != null) ...[
            const SizedBox(height: 12),
            Obx(() => Text(
                  "Auto confirming in ${timerText.value}s",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                )),
          ],
        ],
      ),
      confirm: TextButton(
        onPressed: () {
          countdownTimer?.cancel();
          Get.back();
          onConfirm();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: MyColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(confirmText),
      ),
      cancel: TextButton(
        onPressed: () {
          countdownTimer?.cancel();
          if (onCancel != null) onCancel();
          Get.back();
        },
        style: TextButton.styleFrom(
          foregroundColor: MyColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(cancelText),
      ),
    );
  }
}
