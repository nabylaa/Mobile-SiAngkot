import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/data/models/driver_history/driver_history_model.dart';
import 'package:si_angkot/data/models/driver_history/driver_student_activity_model.dart';
import 'package:si_angkot/data/models/student_history/student_history_activity_detail.dart';
import 'package:si_angkot/data/models/student_history/student_history_model.dart';
import 'package:si_angkot/data/remote/history_service.dart';

class HistoryController {
  final HistoryService _historyService = HistoryService();
  final RxBool isLoading = true.obs;
  final Rx<UserModel?> selectedStudentHistory = Rx<UserModel?>(null);

  //student history
  final RxList<StudentHistoryModel> historyStudentEntries =
      <StudentHistoryModel>[].obs;
  final RxList<StudentHistoryActivityDetail> selectedStudentActivities =
      <StudentHistoryActivityDetail>[].obs;
  final RxList<StudentHistoryActivityDetail> todayStudentActivities =
      <StudentHistoryActivityDetail>[].obs;
  final Rx<StudentHistoryModel?> studentSelectedEntry =
      Rx<StudentHistoryModel?>(null);

  //parent history
  final RxList<StudentHistoryActivityDetail> parentSelectedActivities =
      <StudentHistoryActivityDetail>[].obs;

  //driver history
  final historyList = <DriverHistoryModel>[].obs;
  final historyDetail = <String, List<DriverStudentActivityModel>>{}.obs;
  final selectedDate = ''.obs;
  final selectedDateFormatted = ''.obs;

  // Fetch student history
  // This method fetches the history of a student based on their ID.
  void fetchStudentHistory(String studentId, bool isParent) async {
    try {
      isLoading.value = true;
      print("Fetching student history for ID: $studentId");
      Map<String, List<StudentHistoryActivityDetail>> groupedActivities =
          await _historyService.fetchStudentHistory(studentId);

      print("Grouped activities: $groupedActivities");

      List<StudentHistoryModel> entries = [];

      // Create history entries from the grouped activities
      groupedActivities.forEach((date, activities) {
        entries.add(StudentHistoryModel(
          id: date,
          date: date,
          activities: activities,
        ));
      });

      // Sort entries by date (newest first)
      entries.sort((a, b) => b.date.compareTo(a.date));

      if (isParent) {
        final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final allActivities = entries;
        // Find the entry for today
        final todayEntry =
            allActivities.firstWhereOrNull((entry) => entry.date == todayStr);
        todayStudentActivities.value = todayEntry?.activities ?? [];
      }
      historyStudentEntries.value = entries;
      print("History student entries: ${historyStudentEntries.length}");
    } catch (e) {
      print("Error fetching student history: $e");
      AppUtils.showSnackbar("Oops", "Gagal mendapatkan data history",
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void selectStudentEntry(StudentHistoryModel entry) {
    studentSelectedEntry.value = entry;
    selectedStudentActivities.value =
        entry.activities; // Pastikan ini dipanggil dan listnya sudah update
  }

  void selectStudentHistory(UserModel student) {
    selectedStudentHistory.value = student;
  }

  //fetch driver history
  // This method fetches the history of a driver based on their ID.
  Future<void> fetchHistoryList(String? driverId) async {
    try {
      isLoading.value = true;
      if (driverId == null) {
        _errorGetData(
          'Sepertinya gagal mendapatkan data driver, coba lagi nanti.',
        );
        return;
      }
      final result = await _historyService.fetchDriverHistoryList(driverId);
      print("Driver history entries: ${result.length}");
      historyList.value = result;
    } catch (e) {
      _errorGetData(
        'Gagal memuat riwayat: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHistoryDetail(
      String? driverId, String dateKey, String formattedDate) async {
    try {
      isLoading.value = true;
      if (driverId == null) {
        _errorGetData(
          'Sepertinya gagal mendapatkan data driver, coba lagi nanti.',
        );
        return;
      }
      selectedDate.value = dateKey;
      selectedDateFormatted.value = formattedDate;

      final result =
          await _historyService.fetchDriverHistoryDetail(driverId, dateKey);
      historyDetail.value = result;

      // Navigate to detail page
      Get.toNamed(AppRoutes.driverDetailHistory);
    } catch (e) {
      _errorGetData(
        'Gagal memuat detail riwayat: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshHistoryList(String? driverId) async {
    await fetchHistoryList(driverId);
  }

  void _errorGetData(String message) {
    Get.back();
    AppUtils.showSnackbar(
      'Error',
      message,
      isError: true,
    );
  }

  // Get formatted date for detail page
  String getFormattedDetailDate() {
    if (selectedDateFormatted.value.isNotEmpty) {
      try {
        final date = DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
            .parse(selectedDateFormatted.value);
        return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
      } catch (e) {
        return selectedDateFormatted.value;
      }
    }
    return '';
  }

  // Get total activities count for a date
  int getTotalActivitiesCount(List<DriverStudentActivityModel> activities) {
    return activities.length;
  }

  // Get activities by duty type
  List<DriverStudentActivityModel> getActivitiesByDutyType(String dutyType) {
    return historyDetail[dutyType] ?? [];
  }

  // Check if has berangkat activities
  bool hasBerangkatActivities() {
    return historyDetail['berangkat']?.isNotEmpty ?? false;
  }

  // Check if has pulang activities
  bool hasPulangActivities() {
    return historyDetail['pulang']?.isNotEmpty ?? false;
  }
}
