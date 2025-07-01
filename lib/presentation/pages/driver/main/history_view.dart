import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';

import '../../../controller/history_controller.dart';

class DriverHistoryView extends StatefulWidget {
  const DriverHistoryView({super.key});

  @override
  State<DriverHistoryView> createState() => _DriverHistoryViewState();
}

class _DriverHistoryViewState extends State<DriverHistoryView> {
  final HistoryController controller = Get.put(HistoryController());
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Fetch the history list for the driver
    controller.fetchHistoryList(authController.currentUser?.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'History',
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
              color: Colors.orange,
            ),
          );
        }

        if (controller.historyList.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada riwayat',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              controller.refreshHistoryList(authController.currentUser?.userId),
          color: Colors.orange,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.historyList.length,
            itemBuilder: (context, index) {
              final history = controller.historyList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  title: Text(
                    history.date,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 24,
                  ),
                  onTap: () {
                    controller.fetchHistoryDetail(
                        authController.currentUser?.userId,
                        history.id,
                        history.date);
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
