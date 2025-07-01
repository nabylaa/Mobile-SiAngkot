import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';

class StudentPendingScreen extends StatelessWidget {
  StudentPendingScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pending_actions,
                  size: 80,
                  color: MyColors.primaryColor,
                ),
                SizedBox(height: 20),
                Text(
                  'Verification Pending',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Your account is waiting for verification from an administrator. ' +
                        'You\'ll be automatically redirected once your account is verified.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
                if (authController.isLoading.value) CircularProgressIndicator(),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      'Status Check',
                      'Still waiting for verification. Please be patient.',
                      duration: Duration(seconds: 3),
                    );
                  },
                  child: Text('Check Status',
                      style: AppTextStyle.textBASEPoppins.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
