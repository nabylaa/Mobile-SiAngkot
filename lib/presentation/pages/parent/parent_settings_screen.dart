import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/controller/parent_controller.dart';
import 'package:si_angkot/presentation/widgets/custom_gradient_button.dart';
import 'package:si_angkot/presentation/widgets/custom_text_fields.dart';

import '../../../data/models/users_model.dart';

class ParentSettingsScreen extends StatefulWidget {
  ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  final ParentController parentController = Get.find<ParentController>();
  final AuthController authController = Get.find<AuthController>();

  late TextEditingController nameController;

  late TextEditingController addressController;

  late TextEditingController phoneController;

  // late TextEditingController emailController;

  // late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController =
        TextEditingController(text: authController.currentUser?.name ?? "");
    addressController =
        TextEditingController(text: authController.currentUser?.address ?? "");
    phoneController =
        TextEditingController(text: authController.currentUser?.phone ?? "");
    // emailController =
    //     TextEditingController(text: authController.currentUser?.email ?? "");
    // passwordController = TextEditingController();
  }

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
          Constant.SETTING,
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[300],
                          child:
                              Icon(Icons.person, size: 50, color: Colors.white),
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
                    SizedBox(height: 20),
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
                    // CustomTextField(
                    //   controller: emailController,
                    //   hintText: Constant.EMAIL,
                    //   label: Constant.EMAIL,
                    //   borderColor: MyColors.borderInputText,
                    //   keyboardType: TextInputType.emailAddress,
                    // ),
                    // CustomTextField(
                    //   controller: passwordController,
                    //   hintText: Constant.PASSWORD,
                    //   label: Constant.PASSWORD,
                    //   borderColor: MyColors.borderInputText,
                    //   keyboardType: TextInputType.visiblePassword,
                    //   isPassword: true,
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomGradientButton(
              text: Constant.SAVE,
              onPressed: () {
                parentController.nameTemp.value = nameController.text;
                parentController.addressTemp.value = addressController.text;
                parentController.phoneTemp.value = phoneController.text;
                // parentController.emailTemp.value = emailController.text;

                UserModel updatedUser = authController.currentUser!.copyWith(
                  name: parentController.nameTemp.value,
                  phone: parentController.phoneTemp.value,
                  address: parentController.addressTemp.value,
                );

                authController.updateProfile(updatedUser);
              },
            )
          ],
        ),
      ),
    );
  }
}
