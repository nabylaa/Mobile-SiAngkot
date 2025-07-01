class DriverStudentActivityModel {
  final String studentName;
  final String dutyType; // "pulang" atau "berangkat"
  final int timestamp; // onBoardTimestamp
  final String formattedTime;

  DriverStudentActivityModel({
    required this.studentName,
    required this.dutyType,
    required this.timestamp,
    required this.formattedTime,
  });
}
