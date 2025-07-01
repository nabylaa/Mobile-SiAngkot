import 'package:si_angkot/data/models/driver_history/driver_student_activity_model.dart';

class DriverHistoryModel {
  final String id;
  final String date;
  final List<DriverStudentActivityModel> studentActivities;

  DriverHistoryModel({
    required this.id,
    required this.date,
    required this.studentActivities,
  });
}
