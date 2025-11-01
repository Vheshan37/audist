class LoginResponseModel {
  final int statusCode;
  final String message;
  final String? userId;
  final String? email;
  final Map<String, dynamic>? responseData;

  LoginResponseModel({
    required this.statusCode,
    required this.message,
    this.responseData,
    this.userId,
    this.email,
  });
}
