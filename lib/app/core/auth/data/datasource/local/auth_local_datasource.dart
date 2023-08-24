import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entity/login_response_entity.dart';

const KEY_SESSION_TOKEN = 'SESSION_TOKEN';
const keySessionUser = 'SESSION_USER';

abstract class AuthLocalDataSource {
  Future<LoginResponseEntity> getCurrentUser();

  Future<bool> setCurrentUser(LoginResponseEntity user);

  Future<bool> setToken(String token);

  Future<String> getToken();

  Future<bool> cleanTokens();
}

class AuthLocalDatasourceImpl implements AuthLocalDataSource {
  const AuthLocalDatasourceImpl();

  @override
  Future<LoginResponseEntity> getCurrentUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final userJsonString = sharedPreferences.getString(
      keySessionUser,
    );

    if (userJsonString == null) throw Exception("Não Usuários disponíveis");

    final result = LoginResponseEntity.fromMap(jsonDecode(userJsonString));

    return result;
  }

  @override
  Future<bool> setCurrentUser(LoginResponseEntity user) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final userJson = jsonEncode(user.toMap());
    final result = sharedPreferences.setString(
      keySessionUser,
      userJson,
    );

    return result;
  }

  @override
  Future<String> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final schoolYearString = sharedPreferences.getString(
      KEY_SESSION_TOKEN,
    );

    if (schoolYearString == null) {
      throw Exception("Não há TOKEN disponível");
    }

    return schoolYearString;
  }

  @override
  Future<bool> setToken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final result = sharedPreferences.setString(
      KEY_SESSION_TOKEN,
      token,
    );

    return result;
  }

  @override
  Future<bool> cleanTokens() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final result = await sharedPreferences.remove(KEY_SESSION_TOKEN);
    final resultUser = await sharedPreferences.remove(keySessionUser);

    return result == (resultUser == true);
  }
}
