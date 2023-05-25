import 'package:elesson/app/core/auth/data/model/user_model.dart';
import 'package:elesson/app/core/auth/domain/entity/login_response_entity.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  LoginResponseEntity _user = LoginResponseEntity.empty();

  LoginResponseEntity get user => _user;

  void setUser(LoginResponseEntity user) {
    _user = user;
    notifyListeners();
  }
}
