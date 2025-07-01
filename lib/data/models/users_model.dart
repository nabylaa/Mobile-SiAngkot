class UserModel {
  String userId;
  final String name;
  final String address;
  final String role;
  final String email;
  final String picture;
  final String phone;
  final String? trackingId;
  final bool? isVerify;
  final String? nisn;
  final String? school;
  final String? schoolAddress;

  UserModel({
    required this.userId,
    required this.name,
    required this.address,
    required this.role,
    required this.picture,
    required this.email,
    required this.phone,
    this.trackingId,
    this.isVerify,
    this.nisn,
    this.school,
    this.schoolAddress,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserModel(
      userId: userId,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      role: map['role'] ?? '',
      email: map['email'] ?? '',
      picture: map['picture'] ?? '',
      phone: map['phone'] ?? '',
      trackingId: map['trackingId'] ?? '',
      isVerify: map['isVerify'] ?? false,
      nisn: map['nisn'] ?? '',
      school: map['school'] ?? '',
      schoolAddress: map['schoolAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'role': role,
      'email': email,
      'picture': picture,
      'phone': phone,
      'trackingId': trackingId,
      'isVerify': isVerify,
      'nisn': nisn,
      'school': school,
      'schoolAddress': schoolAddress,
    };
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? role,
    String? picture,
    String? trackingId,
    bool? isVerify,
    String? nisn,
    String? school,
    String? schoolAddress,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      role: role ?? this.role,
      picture: picture ?? this.picture,
      trackingId: trackingId ?? this.trackingId,
      isVerify: isVerify ?? this.isVerify,
      nisn: nisn ?? this.nisn,
      school: school ?? this.school,
      schoolAddress: schoolAddress ?? this.schoolAddress,
    );
  }
}
