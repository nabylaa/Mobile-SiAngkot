import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';

// Custom TextField Widget
class CustomTextField extends StatefulWidget {
  final String hintText;
  final Color hintColor;
  final bool isPassword;
  final TextEditingController? controller;
  final String? label;
  final double maxWidth;
  final Color borderColor;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.hintColor = MyColors.fontColorHint,
    this.isPassword = false,
    this.label,
    this.maxWidth = double.infinity,
    this.keyboardType = TextInputType.text,
    required this.borderColor,
    this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Text(
                  widget.label!,
                  style: AppTextStyle.textBASEPoppins.copyWith(
                    fontWeight: FontWeight.w500,
                    color: MyColors.iconColor1E1E1E,
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            style: AppTextStyle.textBASEPoppins,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              hintStyle: AppTextStyle.textBASEPoppins
                  .copyWith(color: MyColors.fontColorSecondary),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: MyColors.primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: widget.borderColor, width: 3.0),
              ),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Transform.scale(
                        scale: 0.5, // Coba ubah nilainya antara 0.5 - 0.8
                        child: SvgPicture.asset(
                          _obscureText
                              ? MyAssets.svg.passwordOff.path
                              : MyAssets.svg.passwordOn.path,
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              MyColors.fontColorSecondary, BlendMode.srcIn),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// use this widget like this
// CustomTextField(hintText: "Enter your email"),
// CustomTextField(hintText: "Enter password", isPassword: true),
