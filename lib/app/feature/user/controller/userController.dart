import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elesson/app/core/auth/data/model/user_model.dart';
import 'package:elesson/app/util/network/constants.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {

  Future saveUser(UserModel user) async {
    final prefs =await  SharedPreferences.getInstance();
    await prefs.setString('SESSION_USER', jsonEncode(user.toJson()));
  }

  Future<UserModel> recoverUser() async {
    final prefs =await  SharedPreferences.getInstance();
    final String? user = prefs.getString('SESSION_USER');
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user));
    }
    return UserModel.empty();
  }

  Future logout() async {
    final prefs =await  SharedPreferences.getInstance();
    await prefs.remove('SESSION_USER');
  }

  Future<UserModel> getUserById(int id) async {
    try {
      Response response = await DioAuthed().dio.get('$URLBASE/user/$id');
      UserModel user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e);
      return UserModel.empty();
    }
  }

  Future<UserModel> getUserByName(String name) async {
    try {
      Response response = await DioAuthed().dio.get('$URLBASE/user/name/$name');
      UserModel user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e);
      return UserModel.empty();
    }
  }

  Future<UserModel> addUser(UserModel user) async {
    try {
      Response response = await DioAuthed().dio.post('$URLBASE/user', data: user.toJsonAdd());
      UserModel resUser = UserModel.fromJson(response.data);
      return resUser;
    } catch (e) {
      print(e);
      return UserModel.empty();
    }
  }

  Future<UserModel> login(String name, String password) async {
    try {
      Response response = await DioAuthed().dio.post('$URLBASE/user/login', data: {'user_name': name, 'password': password});
      UserModel user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e);
      return UserModel.empty();
    }
  }

  Future<UserModel> updateUser(UserModel user) async {
    try {
      Response response = await DioAuthed().dio.put('$URLBASE/user', data: user.toJsonUpdate());
      UserModel resUser = UserModel.fromJson(response.data);
      return resUser;
    } catch (e) {
      print(e);
      return UserModel.empty();
    }
  }

}
