import 'dart:convert';
//UNUSED

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? token;
  String role;

  LoginModel({
    this.token,
    required this.role,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "role": role,
      };
}
