import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/controller/parent_controller.dart';
import 'package:si_angkot/presentation/widgets/custom_gradient_button.dart';
import 'package:si_angkot/presentation/widgets/custom_text_fields.dart';

class RegisterStudentScreen extends StatelessWidget {
  RegisterStudentScreen({super.key});
  final ParentController controller = Get.put(ParentController());
  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressSchoolController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      appBar: AppBar(
        backgroundColor: MyColors.colorWhite,
        surfaceTintColor: Colors.transparent,
        leading: Center(
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: MyAssets.svg.arrowLeft.svg(
              width: 30,
              height: 30,
            ),
          ),
        ),
        title: Text(
          Constant.REGISTER_CHILDREN,
          style: AppTextStyle.textXLPoppins.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Obx(
                        () => Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  controller.imageFile.value != null
                                      ? FileImage(controller.imageFile.value!)
                                      : null,
                              child: controller.imageFile.value == null
                                  ? Icon(Icons.person,
                                      size: 50, color: Colors.white)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(4),
                                child: MyAssets.svg.upload.svg(
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                        MyColors.fontColorSecondary,
                                        BlendMode.srcIn)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      hintText: Constant.FULL_NAME,
                      label: Constant.FULL_NAME,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.name,
                    ),
                    CustomTextField(
                      controller: nisnController,
                      hintText: Constant.NISN,
                      label: Constant.NISN,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextField(
                      controller: schoolController,
                      hintText: Constant.SCHOOL,
                      label: Constant.SCHOOL,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.name,
                    ),
                    CustomTextField(
                      controller: addressSchoolController,
                      hintText: Constant.SCHOOL_ADDRESS,
                      label: Constant.SCHOOL_ADDRESS,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () {
                if (authController.isLoading.value) {
                  return CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
                  );
                } else {
                  return CustomGradientButton(
                    text: Constant.REGISTER,
                    onPressed: () async {
                      bool register = await authController.registerStudent(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                        phone: phoneController.text,
                        address: addressSchoolController.text,
                        nisn: nisnController.text,
                        school: schoolController.text,
                        schoolAddress: addressSchoolController.text,
                        picture: controller.imageFile.value != null
                            ? controller.imageFile.value!.path
                            : '',
                      );
                      if (register) {
                        AppUtils.showSnackbar(
                            "Success", "Berhasil mendaftarkan student");
                        controller.resetDataInfo();
                        controller.imageFile.value = null;
                        nameController.clear();
                        addressSchoolController.clear();
                        schoolController.clear();
                        nisnController.clear();
                        phoneController.clear();
                        emailController.clear();
                        passwordController.clear();
                      } else {
                        AppUtils.showSnackbar(
                            "Failed", "Gagal mendaftarkan student",
                            isError: true);
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
