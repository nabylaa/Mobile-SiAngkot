import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';

import '../../widgets/custom_gradient_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                'Forgot Password',
                style: AppTextStyle.textHeadingPoppins.copyWith(
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Masukkan alamat email yang terdaftar dengan akun Anda. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.',
                style: AppTextStyle.textBASEPoppins.copyWith(
                  overflow: TextOverflow.visible,
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),

              // Email Address Label
              Text(
                'Email Address',
                style: AppTextStyle.textBASEPoppins.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // Email Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyle.textBASEPoppins.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'email@example.com',
                    hintStyle: AppTextStyle.textBASEPoppins.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () {
                    if (authController.isLoading.value) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.primaryColor),
                      );
                    } else {
                      return CustomGradientButton(
                        text: Constant.SEND,
                        onPressed: () {
                          authController.isLoading.value = true;
                          authController
                              .resetPassword(emailController.text)
                              .then((_) {
                            emailController.clear();
                          });
                        },
                      );
                    }
                  },
                ),
              ),

              const Spacer(),

              // Remember Password Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remembered password? ',
                      style: AppTextStyle.textBASEPoppins.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        'Login to your account',
                        style: AppTextStyle.textBASEPoppins.copyWith(
                          fontSize: 14,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
