import 'dart:convert';

//UNUSED
Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  int? code;
  String? message;
  StudentData? data;

  Users({
    this.code,
    this.message,
    this.data,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : StudentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class StudentData {
  int? id;
  String? name;
  String? school;
  String? email;
  String? number;
  String? pict;
  String? schoolAddress;
  String? status;
  String? phone;

  StudentData({
    this.id,
    this.name,
    this.school,
    this.email,
    this.number,
    this.pict,
    this.schoolAddress,
    this.status,
    this.phone,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
        id: json["id"],
        name: json["name"],
        school: json["school"],
        email: json["email"],
        number: json["number"],
        pict: json["pict"],
        schoolAddress: json["school_address"],
        status: json["status"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "school": school,
        "email": email,
        "number": number,
        "pict": pict,
        "school_address": schoolAddress,
        "status": status,
        "phone": phone,
      };
}
