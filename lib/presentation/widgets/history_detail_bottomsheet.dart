import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/presentation/controller/history_controller.dart';

import '../../core/utils/app_text_style.dart';
import '../../gen/colors.gen.dart';

class HistoryDetailBottomSheet extends StatelessWidget {
  HistoryDetailBottomSheet({super.key});
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Obx(() {
            if (controller.studentSelectedEntry.value == null) {
              return Center(child: Text('No data available'));
            }

            DateTime entryDate = DateFormat('yyyy-MM-dd')
                .parse(controller.studentSelectedEntry.value!.date);
            String formattedDate =
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(entryDate);

            return ListView(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: AppTextStyle.textHeadingPoppins.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF6B35),
                  ),
                ),
                Divider(height: 20, color: Colors.grey.shade300),
                ...controller.selectedStudentActivities.map((activity) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity.type,
                          style: AppTextStyle.textBASEPoppins.copyWith(
                            fontSize: 14,
                            color: MyColors.fontColorListItem,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey.shade600),
                            SizedBox(width: 8),
                            Text(
                              activity.time,
                              style: AppTextStyle.textBASEPoppins.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }),
        );
      },
    );
  }
}
