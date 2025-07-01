import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';

import '../../controller/history_controller.dart';

class StudentDetailHistoryScreen extends StatelessWidget {
  StudentDetailHistoryScreen({super.key});
  final HistoryController controller = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: Text(
          'Detail History',
          style: AppTextStyle.textHeadingPoppins.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.studentSelectedEntry.value == null) {
          return Center(child: Text('No data selected'));
        }

        // Mengubah format tanggal untuk header
        DateTime entryDate = DateFormat('yyyy-MM-dd')
            .parse(controller.studentSelectedEntry.value!.date);
        String formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(entryDate);

        for (var activity in controller.selectedStudentActivities) {
          print("Selected Entry: ${activity.type}");
        }
        print(
            "Selected Entry: ${controller.studentSelectedEntry.value!.activities.length}");

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Text(
                formattedDate,
                style: AppTextStyle.textHeadingPoppins.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6B35), // Orange color
                ),
              ),
              Divider(
                height: 20,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 8),
              // Activities List
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.selectedStudentActivities.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 32,
                    color: Colors.grey.shade300,
                  ),
                  itemBuilder: (context, index) {
                    final activity =
                        controller.selectedStudentActivities[index];
                    print("Student activity: ${activity.type}");

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activity.type,
                            style: AppTextStyle.textBASEPoppins.copyWith(
                              fontSize: 16,
                              color: MyColors.fontColorListItem,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 8),
                              Text(
                                activity.time,
                                style: AppTextStyle.textBASEPoppins.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
