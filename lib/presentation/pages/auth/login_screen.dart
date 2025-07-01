import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/core/utils/helper/size_helper.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/widgets/custom_gradient_button.dart';
import 'package:si_angkot/presentation/widgets/custom_text_fields.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../gen/colors.gen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyAssets.png.icon.image(
                        width: SizeHelper.dynamicWidth(80),
                        height: SizeHelper.dynamicHeight(80),
                        cacheHeight: 80,
                        cacheWidth: 80,
                      ),
                      GradientText(
                        Constant.APP_NAME,
                        style: AppTextStyle.text3XLInter.copyWith(fontSize: 32),
                        gradientType: GradientType.linear,
                        gradientDirection: GradientDirection.ltr,
                        colors: [
                          MyColors.primaryColor,
                          MyColors.secondaryColor,
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GradientText(
                        Constant.APP_DESCRIPTION,
                        style: AppTextStyle.textHeadingInter
                            .copyWith(fontSize: 14),
                        gradientType: GradientType.linear,
                        gradientDirection: GradientDirection.ltr,
                        colors: [
                          MyColors.primaryColor,
                          MyColors.secondaryColor
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: Constant.EMAIL,
                              borderColor: MyColors.borderInputTextSecondary,
                              hintColor: MyColors.borderInputTextSecondary,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                            ),
                            CustomTextField(
                              hintText: Constant.PASSWORD,
                              isPassword: true,
                              borderColor: MyColors.borderInputTextSecondary,
                              hintColor: MyColors.borderInputTextSecondary,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () =>
                                    Get.toNamed(AppRoutes.forgotPassword),
                                child: Text(
                                  Constant.FORGOT_PASSWORD,
                                  style: AppTextStyle.textBASEPoppins.copyWith(
                                    color: MyColors.fontColorSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Obx(
                              () {
                                if (authController.isLoading.value) {
                                  return CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        MyColors.primaryColor),
                                  );
                                } else {
                                  return CustomGradientButton(
                                    text: Constant.LOGIN,
                                    onPressed: () {
                                      authController.login(emailController.text,
                                          passwordController.text);
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeHelper.dynamicHeight(30)),
                    child: RichText(
                      text: TextSpan(
                        text: Constant.DOESNT_HAVE_ACCOUNT,
                        style: AppTextStyle.textBASEPoppins
                            .copyWith(color: MyColors.fontColorSecondary),
                        children: [
                          TextSpan(
                            text: ' ${Constant.REGISTER}',
                            style: AppTextStyle.textBASEPoppins.copyWith(
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppRoutes.baseRegister);
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
// body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 MyAssets.png.icon.image(
//                   width: SizeHelper.dynamicWidth(80),
//                   height: SizeHelper.dynamicHeight(80),
//                   cacheHeight: 80,
//                   cacheWidth: 80,
//                 ),
//                 GradientText(
//                   Constant.APP_NAME,
//                   style: AppTextStyle.text3XLInter.copyWith(fontSize: 32),
//                   gradientType: GradientType.linear,
//                   gradientDirection: GradientDirection.ltr,
//                   colors: [
//                     MyColors.primaryColor,
//                     MyColors.secondaryColor,
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 GradientText(
//                   Constant.APP_DESCRIPTION,
//                   style: AppTextStyle.textHeadingInter.copyWith(fontSize: 14),
//                   gradientType: GradientType.linear,
//                   gradientDirection: GradientDirection.ltr,
//                   colors: [MyColors.primaryColor, MyColors.secondaryColor],
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 50),
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         hintText: Constant.EMAIL,
//                         borderColor: MyColors.borderInputTextSecondary,
//                         hintColor: MyColors.borderInputTextSecondary,
//                         keyboardType: TextInputType.emailAddress,
//                         controller: emailController,
//                       ),
//                       CustomTextField(
//                         hintText: Constant.PASSWORD,
//                         isPassword: true,
//                         borderColor: MyColors.borderInputTextSecondary,
//                         hintColor: MyColors.borderInputTextSecondary,
//                         keyboardType: TextInputType.visiblePassword,
//                         controller: passwordController,
//                       ),
//                       const SizedBox(height: 15),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: InkWell(
//                           onTap: () => AppUtils.showSnackbar(
//                               "On Click", "Forgot Password Clicked"),
//                           child: Text(
//                             Constant.FORGOT_PASSWORD,
//                             style: AppTextStyle.textBASEPoppins.copyWith(
//                               color: MyColors.fontColorSecondary,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Obx(
//                         () {
//                           if (authController.isLoading.value) {
//                             return CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                   MyColors.primaryColor),
//                             );
//                           } else {
//                             return CustomGradientButton(
//                               text: Constant.LOGIN,
//                               onPressed: () {
//                                 authController.login(emailController.text,
//                                     passwordController.text);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: SizeHelper.dynamicHeight(30)),
//               child: RichText(
//                 text: TextSpan(
//                   text: Constant.DOESNT_HAVE_ACCOUNT,
//                   style: AppTextStyle.textBASEPoppins
//                       .copyWith(color: MyColors.fontColorSecondary),
//                   children: [
//                     TextSpan(
//                       text: ' ${Constant.REGISTER}',
//                       style: AppTextStyle.textBASEPoppins.copyWith(
//                           color: MyColors.primaryColor,
//                           fontWeight: FontWeight.w700),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Get.toNamed(AppRoutes.baseRegister);
//                         },
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
