import 'package:elesson/app/core/auth/data/model/user_model.dart';
import 'package:elesson/app/feature/user/controller/userController.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel.empty();

  UserModel get user => _user;

  UserController _userController = UserController();

  void setUser(UserModel user) {
    _user = user;
  }

  Future<UserModel?>recoverUser() async {
    _user = await _userController.recoverUser();
    // notifyListeners();
    return _user;
  }

  Future<void> logout() async {
    _user = UserModel.empty();
    await _userController.logout();
    return;
  }

}
