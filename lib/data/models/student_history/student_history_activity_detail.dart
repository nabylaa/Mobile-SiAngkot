class StudentHistoryActivityDetail {
  final String type;
  final String time;
  final int timestamp;

  StudentHistoryActivityDetail({
    required this.type,
    required this.time,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'StudentHistoryActivityDetail(type: $type, time: $time, timestamp: $timestamp)';
  }
}
