class ParentStudentHistoryModel {
  final String id;
  final String date;
  final String dutyType; // berangkat atau pulang
  final int? onBoardTimestamp;
  final int? offBoardTimestamp;
  final String? onBoardTime;
  final String? offBoardTime;
  final bool isExpanded;

  ParentStudentHistoryModel({
    required this.id,
    required this.date,
    required this.dutyType,
    this.onBoardTimestamp,
    this.offBoardTimestamp,
    this.onBoardTime,
    this.offBoardTime,
    this.isExpanded = false,
  });

  ParentStudentHistoryModel copyWith({
    String? id,
    String? date,
    String? dutyType,
    int? onBoardTimestamp,
    int? offBoardTimestamp,
    String? onBoardTime,
    String? offBoardTime,
    bool? isExpanded,
  }) {
    return ParentStudentHistoryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      dutyType: dutyType ?? this.dutyType,
      onBoardTimestamp: onBoardTimestamp ?? this.onBoardTimestamp,
      offBoardTimestamp: offBoardTimestamp ?? this.offBoardTimestamp,
      onBoardTime: onBoardTime ?? this.onBoardTime,
      offBoardTime: offBoardTime ?? this.offBoardTime,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
