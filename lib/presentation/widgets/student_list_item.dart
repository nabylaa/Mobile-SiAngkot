import 'package:flutter/material.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';

class StudentListItem extends StatelessWidget {
  final String name;
  final String school;
  final bool status;
  final String profileImageUrl;
  final VoidCallback onTap;

  const StudentListItem({
    Key? key,
    required this.name,
    required this.school,
    required this.status,
    required this.profileImageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : null,
              child: profileImageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),

            // Name & School Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyColors.fontColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    school,
                    style: TextStyle(
                      fontSize: 14,
                      color: MyColors.fontColorSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status
                          ? MyColors.backgroundSuccess
                          : MyColors.backgroundWarning,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(status ? "Terdaftar" : "Menunggu Verifikasi",
                        style: AppTextStyle.textBASEPoppins.copyWith(
                          color: status
                              ? MyColors.fontColorSuccess
                              : MyColors.fontColorWarning,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            MyAssets.svg.arrowRight.svg(
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                    MyColors.fontColorSecondary, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }
}
