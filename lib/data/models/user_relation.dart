class UserRelation {
  final String parentId;
  final Map<String, dynamic> students;

  UserRelation({
    required this.parentId,
    required this.students,
  });

  factory UserRelation.fromMap(Map<String, dynamic> map, String parentId) {
    return UserRelation(
      parentId: parentId,
      students: Map<String, dynamic>.from(map['students'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'students': students,
    };
  }
}
