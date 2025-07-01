import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';

class QRCard extends StatelessWidget {
  final String id;
  const QRCard({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: MyColors.colorWhite,
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              Constant.SCAN_QR,
              style: AppTextStyle.textXLPoppins.copyWith(
                color: MyColors.fontColorPrimary,
              ),
            ),
            SizedBox(height: 10),
            QrImageView(
              data: id,
              version: QrVersions.auto,
              size: 250.0,
            ),
            SizedBox(height: 10),
            Text(
              Constant.SCAN_QR_DESC,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: AppTextStyle.textBASEPoppins.copyWith(
                color: MyColors.fontColorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
