import 'package:flutter/material.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedFontColor;
  final Color selectedIconColor;
  final Color unselectedFontColor;
  final Color unselectedIconColor;

  const CustomBottomNavigationItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.selectedFontColor = MyColors.primaryColor,
    this.selectedIconColor = MyColors.primaryColor,
    this.unselectedFontColor = MyColors.bottomNavFontColorUnselected,
    this.unselectedIconColor = MyColors.bottomNavIconColorUnselected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontColor = isSelected ? selectedFontColor : unselectedFontColor;
    final iconColor = isSelected ? selectedIconColor : unselectedIconColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor),
        // Menambahkan jarak antara icon dan label
        SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.textHeadingLGPoppins.copyWith(
              color: fontColor, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
