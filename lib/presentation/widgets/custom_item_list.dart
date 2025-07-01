import 'package:flutter/material.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';

class CustomItemList extends StatelessWidget {
  final String title;
  final String? time;
  final VoidCallback? onTap;

  const CustomItemList({
    super.key,
    required this.title,
    this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.textBASEPoppins),
              ],
            ),
            if (time != null)
              Row(
                children: [
                  MyAssets.svg.clock.svg(
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                          MyColors.iconColor1E1E1E, BlendMode.srcIn)),
                  const SizedBox(width: 6),
                  Text(
                    time!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              // Icon(MyAssets.svg.arrowRight as IconData ,color: MyColors.iconColor1E1E1E),
              MyAssets.svg.arrowRight.svg(
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                      MyColors.iconColor1E1E1E, BlendMode.srcIn))
          ],
        ),
      ),
    );
  }
}
