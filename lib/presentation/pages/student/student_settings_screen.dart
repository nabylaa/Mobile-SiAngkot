import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';

class StudentSettingScreen extends StatefulWidget {
  StudentSettingScreen({super.key});

  @override
  State<StudentSettingScreen> createState() => _StudentSettingScreenState();
}

class _StudentSettingScreenState extends State<StudentSettingScreen> {
  final StudentController studentController = Get.put(StudentController());
  final AuthController authController = Get.find<AuthController>();

  late TextEditingController nameController;

  late TextEditingController addressSchoolController;

  late TextEditingController schoolController;

  late TextEditingController nisnController;

  late TextEditingController phoneController;

  // late TextEditingController emailController;

  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: authController.currentUser?.name ?? "");
    addressSchoolController = TextEditingController(
        text: authController.currentUser?.schoolAddress ?? "");
    phoneController =
        TextEditingController(text: authController.currentUser?.phone ?? "");
    addressController =
        TextEditingController(text: authController.currentUser?.address ?? "");
    nisnController =
        TextEditingController(text: authController.currentUser?.nisn ?? "");
    // emailController =
    // TextEditingController(text: authController.currentUser?.email ?? "");
    schoolController =
        TextEditingController(text: authController.currentUser?.school ?? "");
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
                      controller: nisnController,
                      hintText: Constant.NISN,
                      label: Constant.NISN,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.name,
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
                      controller: addressController,
                      hintText: Constant.ADDRESS,
                      label: Constant.ADDRESS,
                      borderColor: MyColors.borderInputText,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    // CustomTextField(
                    //   controller: emailController,
                    //   hintText: Constant.EMAIL,
                    //   label: Constant.EMAIL,
                    //   borderColor: MyColors.borderInputText,
                    //   keyboardType: TextInputType.emailAddress,
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomGradientButton(
              text: Constant.SAVE,
              onPressed: () {
                studentController.nameTemp.value = nameController.text;
                studentController.schoolAddressTemp.value =
                    addressSchoolController.text;
                studentController.schoolTemp.value = schoolController.text;
                studentController.nisnTemp.value = nisnController.text;
                // studentController.emailTemp.value = addressController.text;
                studentController.phoneTemp.value = phoneController.text;
                studentController.addressTemp.value = addressController.text;

                UserModel updatedUser = authController.currentUser!.copyWith(
                  name: studentController.nameTemp.value,
                  school: studentController.schoolTemp.value,
                  schoolAddress: studentController.schoolAddressTemp.value,
                  nisn: studentController.nisnTemp.value,
                  phone: studentController.phoneTemp.value,
                  address: studentController.addressTemp.value,
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
