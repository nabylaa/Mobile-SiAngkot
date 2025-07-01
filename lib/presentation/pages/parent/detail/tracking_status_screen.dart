import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_text_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../controller/history_controller.dart';

class TrackingStatusScreen extends StatelessWidget {
  TrackingStatusScreen({super.key});
  final HistoryController controller = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Obx(() {
        if (controller.todayStudentActivities.isEmpty) {
          return Center(child: Text('No data found'));
        }
        String formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

        for (var activity in controller.todayStudentActivities) {
          print("Selected Entry: ${activity.type}");
        }
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Text(
                formattedDate,
                style: AppTextStyle.textHeadingPoppins.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
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
                  itemCount: controller.todayStudentActivities.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 32,
                    color: Colors.grey.shade300,
                  ),
                  itemBuilder: (context, index) {
                    final activity = controller.todayStudentActivities[index];
                    print("Student activity: ${activity.type}");

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
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
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
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
