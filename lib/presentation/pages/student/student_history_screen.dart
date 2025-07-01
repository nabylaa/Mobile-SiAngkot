import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/presentation/controller/history_controller.dart';
import 'package:si_angkot/presentation/pages/student/student_detail_history_screen.dart';

import '../../controller/auth_controller.dart';

class StudentHistoryScreen extends StatefulWidget {
  StudentHistoryScreen({super.key});

  @override
  State<StudentHistoryScreen> createState() => _StudentHistoryScreenState();
}

class _StudentHistoryScreenState extends State<StudentHistoryScreen> {
  final HistoryController controller = Get.put(HistoryController());
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    controller.fetchStudentHistory(
        authController.currentUser?.userId ?? '', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite, // Light gray background
      appBar: AppBar(
        title: Text(
          'History',
          style: AppTextStyle.textHeadingPoppins.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColors.colorWhite, // Same as body background
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
          margin: EdgeInsets.all(16),
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
                    Get.to(() => StudentDetailHistoryScreen());
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
