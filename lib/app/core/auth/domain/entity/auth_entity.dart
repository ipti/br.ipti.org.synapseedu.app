class AuthEntity {
  final String username;
  final String password;

  AuthEntity({
    required this.username,
    required this.password,
  });

  factory AuthEntity.fromMap(Map<String, dynamic> map) {
    return AuthEntity(
      username: map['user_name'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_name': username,
      'password': password,
    };
  }

}
