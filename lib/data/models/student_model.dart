class StudentModel {
  final String? trackingId;
  final bool isVerify;
  final String nisn;
  final String school;
  final String schoolAddress;

  StudentModel({
    this.trackingId,
    required this.isVerify,
    required this.nisn,
    required this.school,
    required this.schoolAddress,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      trackingId: map['trackingId'] ?? '',
      isVerify: map['isVerify'] ?? false,
      nisn: map['nisn'] ?? '',
      school: map['school'] ?? '',
      schoolAddress: map['schoolAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackingId': trackingId,
      'isVerify': isVerify,
      'nisn': nisn,
      'school': school,
      'schoolAddress': schoolAddress,
    };
  }
}
