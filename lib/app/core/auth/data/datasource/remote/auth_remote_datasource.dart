import 'package:dio/dio.dart';
import 'package:elesson/app/util/network/interceptors/auth_interceptor.dart';
import '../../../domain/entity/login_entity.dart';
import '../../../domain/entity/auth_response_entity.dart';
import '../../../domain/entity/login_response_entity.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseEntity> login(LoginEntity LoginEntity);
  Future<AuthResponseEntity> getAccessToken(String userName, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource{
  final Dio dio;

  AuthRemoteDatasourceImpl({required this.dio});

  Future<LoginResponseEntity> login(LoginEntity authLoginEntity) async {
    dio.interceptors.add(AuthInterceptor());
    final response = await dio.post('/user/login', data: authLoginEntity.toJson());

    if(response.data != null){
      final result = LoginResponseEntity.fromMap(response.data!);
      return result;
    }

    throw "Erro desconhecido";
  }

  @override
  Future<AuthResponseEntity> getAccessToken(String userName, String password) async {
    final response = await dio.post('/user/login-system-auth',data: {'user_name': userName, 'password': password});

    if(response.data != null){
      final result = AuthResponseEntity.fromJson(response.data!);
      return result;
    }

    throw "Erro desconhecido";
  }
}