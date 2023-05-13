import 'package:flutter/material.dart';

class LoginEntity {
  final TextEditingController username;
  final TextEditingController password;

  LoginEntity({
    required this.username,
    required this.password,
  });

  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    return LoginEntity(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': username.text,
      'password': password.text
    };
  }

  LoginEntity.empty()
      : username = TextEditingController(),
        password = TextEditingController();

}
