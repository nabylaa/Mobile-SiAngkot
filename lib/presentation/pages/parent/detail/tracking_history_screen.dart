import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/presentation/controller/history_controller.dart';
import 'package:si_angkot/presentation/widgets/history_detail_bottomsheet.dart';

import '../../../../core/utils/app_text_style.dart';
import '../../../../gen/colors.gen.dart';

class TrackingHistoryScreen extends StatelessWidget {
  TrackingHistoryScreen({super.key});
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      body: Obx(() {
        if (controller.isLoading.value == true) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.historyStudentEntries.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada riwayat perjalanan',
              style: AppTextStyle.textHeadingPoppins.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: controller.historyStudentEntries.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade200,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final entry = controller.historyStudentEntries[index];
              // Mengubah format tanggal
              DateTime entryDate = DateFormat('yyyy-MM-dd').parse(entry.date);
              String formattedDate =
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(entryDate);

              return Container(
                decoration: BoxDecoration(
                  color: MyColors.colorWhite,
                  borderRadius: index == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )
                      : index == controller.historyStudentEntries.length - 1
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            )
                          : BorderRadius.zero,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    formattedDate,
                    style: AppTextStyle.textBASEPoppins.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: MyColors.fontColorPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 20,
                  ),
                  onTap: () {
                    controller.selectStudentEntry(entry);
                    _showBottomSheet(context);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => HistoryDetailBottomSheet(),
    );
  }
}
