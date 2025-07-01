import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/driver_history/driver_student_activity_model.dart';
import '../../controller/history_controller.dart';
import '../../controller/tab_controller.dart';
import '../../widgets/chip_tab.dart';

class DriverDetailHistoryScreen extends StatelessWidget {
  DriverDetailHistoryScreen({super.key});
  final HistoryController controller = Get.put(HistoryController());
  final TabControllerX tabController = Get.put(TabControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6B35),
            ),
          );
        }

        return Column(
          children: [
            // ChipTab for Keberangkatan and Pulang
            Container(
              margin: const EdgeInsets.all(16),
              child: ChipTab(
                tabs: const ['Keberangkatan', 'Pulang'],
              ),
            ),

            // Date header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  controller.selectedDateFormatted.value.isNotEmpty
                      ? controller.getFormattedDetailDate()
                      : '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Activity list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount:
                    _getDisplayActivities(controller, tabController).length,
                itemBuilder: (context, index) {
                  final activities =
                      _getDisplayActivities(controller, tabController);
                  final activity = activities[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              activity.formattedTime,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
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
        );
      }),
    );
  }

  List<DriverStudentActivityModel> _getDisplayActivities(
      HistoryController controller, TabControllerX tabController) {
    // Check which tab is selected (0 = Keberangkatan, 1 = Pulang)
    if (tabController.selectedTab.value == 1) {
      return controller.getActivitiesByDutyType('pulang');
    } else {
      return controller.getActivitiesByDutyType('berangkat');
    }
  }
}
