import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/controller/tab_controller.dart';
import 'package:si_angkot/presentation/widgets/chip_tab.dart';
import 'package:si_angkot/presentation/widgets/custom_gradient_button.dart';
import 'package:si_angkot/presentation/widgets/custom_text_fields.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());
  final TabControllerX tabController = Get.put(TabControllerX());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  "Buat Akun",
                  style: AppTextStyle.textLGPoppins.copyWith(
                    fontWeight: FontWeight.w500,
                    color: MyColors.fontColorPrimary,
                  ),
                ),
                Text(
                  "Isi formulir di bawah ini untuk membuat akun Anda.",
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textBASEPoppins.copyWith(
                    color: MyColors.fontColorSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ChipTab(
                  tabs: [Constant.PARENT, Constant.DRIVER],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: nameController,
                  hintText: Constant.FULL_NAME,
                  label: Constant.FULL_NAME,
                  borderColor: MyColors.borderInputText,
                  keyboardType: TextInputType.name,
                ),
                CustomTextField(
                  controller: addressController,
                  hintText: Constant.ADDRESS,
                  label: Constant.ADDRESS,
                  borderColor: MyColors.borderInputText,
                  keyboardType: TextInputType.streetAddress,
                ),
                CustomTextField(
                  controller: phoneController,
                  hintText: Constant.PHONE_NUMBER,
                  label: Constant.PHONE_NUMBER,
                  borderColor: MyColors.borderInputText,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: Constant.EMAIL,
                  label: Constant.EMAIL,
                  borderColor: MyColors.borderInputText,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: Constant.PASSWORD,
                  label: Constant.PASSWORD,
                  borderColor: MyColors.borderInputText,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                Obx(
                  () {
                    if (authController.isLoading.value) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.primaryColor),
                      );
                    } else {
                      return CustomGradientButton(
                        text: Constant.REGISTER,
                        onPressed: () {
                          // AppUtils.showSnackbar(
                          //     "Register BY",
                          //     tabController.selectedTab.value == 0
                          //         ? Constant.PARENT
                          //         : Constant.DRIVER);
                          authController.register(
                            name: nameController.text,
                            address: addressController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            role: tabController.selectedTab.value == 0
                                ? Constant.PARENT
                                : Constant.DRIVER,
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
