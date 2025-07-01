//UNUSED

class FormatModel<T> {
  final int code;
  final String message;
  final T? data;

  FormatModel({required this.code, required this.message, this.data});

  factory FormatModel.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return FormatModel(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
