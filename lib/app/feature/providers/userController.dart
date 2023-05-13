import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elesson/app/core/auth/data/model/user_model.dart';
import 'package:elesson/app/util/network/constants.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {

  UserModel? user;

  Future saveUser(UserModel user) async {
    final prefs =await  SharedPreferences.getInstance();
    await prefs.setString('SESSION_USER', jsonEncode(user.toJson()));
  }

  Future<UserModel?> recoverUser() async {
    final prefs =await  SharedPreferences.getInstance();
    final String? user = prefs.getString('SESSION_USER');
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user));
    }
    return null;
  }

  Future logout() async {
    final prefs =await  SharedPreferences.getInstance();
    await prefs.remove('SESSION_USER');
  }

  Future<UserModel?> getUserById(int id) async {
    try {
      Response response = await DioAuthed().dio.get('$URLBASE/user/$id');
      user = UserModel.fromJson(response.data);
      return user!;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> getUserByName(String name) async {
    try {
      Response response = await DioAuthed().dio.get('$URLBASE/user/name/$name');
      user = UserModel.fromJson(response.data);
      return user!;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> addUser(UserModel user) async {
    try {
      Response response = await DioAuthed().dio.post('$URLBASE/user', data: user.toJsonAdd());
      user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> login(String name, String password) async {
    try {
      Response response = await DioAuthed().dio.post('$URLBASE/user/login', data: {'user_name': name, 'password': password});
      user = UserModel.fromJson(response.data);
      return user!;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> updateUser(UserModel user) async {
    try {
      Response response = await DioAuthed().dio.put('$URLBASE/user', data: user.toJsonUpdate());
      user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
