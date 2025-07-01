import 'package:intl/intl.dart';
import 'package:si_angkot/data/models/student_history/student_history_activity_detail.dart';

class StudentHistoryModel {
  final String id;
  final String date;
  final List<StudentHistoryActivityDetail> activities;

  StudentHistoryModel({
    required this.id,
    required this.date,
    required this.activities,
  });

  factory StudentHistoryModel.fromJson(String id, Map<String, dynamic> json) {
    List<StudentHistoryActivityDetail> activities = [];

    // Jika ada data aktivitas
    if (json['studentId'] != null && json['trackingId'] != null) {
      // Berangkat - Naik
      if (json['onBoardTimestamp'] != null) {
        activities.add(StudentHistoryActivityDetail(
          type: 'Berangkat - Naik',
          time: DateFormat('HH:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(json['onBoardTimestamp']),
          ),
          timestamp: json['onBoardTimestamp'],
        ));
      }

      // Berangkat - Turun
      if (json['offBoardTimestamp'] != null) {
        activities.add(StudentHistoryActivityDetail(
          type: 'Berangkat - Turun',
          time: DateFormat('HH:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(json['offBoardTimestamp']),
          ),
          timestamp: json['offBoardTimestamp'],
        ));
      }

      // Pulang - Naik & Pulang - Turun
      // Ini akan tergantung pada struktur data Anda
      // Kita bisa menggunakannya jika duty type adalah "pulang"
      if (json['dutyType'] == 'pulang') {
        if (json['onBoardTimestamp'] != null) {
          activities.add(StudentHistoryActivityDetail(
            type: 'Pulang - Naik',
            time: DateFormat('HH:mm a').format(
              DateTime.fromMillisecondsSinceEpoch(json['onBoardTimestamp']),
            ),
            timestamp: json['onBoardTimestamp'],
          ));
        }

        if (json['offBoardTimestamp'] != null) {
          activities.add(StudentHistoryActivityDetail(
            type: 'Pulang - Turun',
            time: DateFormat('HH:mm a').format(
              DateTime.fromMillisecondsSinceEpoch(json['offBoardTimestamp']),
            ),
            timestamp: json['offBoardTimestamp'],
          ));
        }
      }
    }

    return StudentHistoryModel(
      id: id,
      date: id, // Asumsi id adalah format tanggal yy-MM-dd
      activities: activities,
    );
  }
}
