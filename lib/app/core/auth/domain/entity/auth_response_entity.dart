class AuthResponseEntity{
  final bool success;
  final String token;
  final String status;

  AuthResponseEntity({
    required this.success,
    required this.token,
    required this.status,
  });

  factory AuthResponseEntity.fromJson(Map<String, dynamic> json) {
    return AuthResponseEntity(
      success: json['success'] ?? false,
      token: json['token'] ?? "",
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'status': status,
    };
  }
}