

class NestError {
  late final dynamic message;
  late final String error;
  late final num statusCode;

  NestError({
    required dynamic this.message,
    required String this.error,
    required num this.statusCode
  }){}

  factory NestError.fromJson(Map<String, dynamic> json) {
    return NestError(
      error: json["error"] ?? "",
      message: json["message"] ?? "",
      statusCode: json["statusCode"] ?? 0,
    );
  }
}