import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elesson/app/core/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:elesson/app/core/auth/domain/entity/auth_response_entity.dart';
import 'package:elesson/app/util/failures/failures.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../data/repository/auth_repository_interface.dart';
import '../entity/login_entity.dart';
import '../entity/login_response_entity.dart';

class AuthRepositoryImpl extends AuthRepositoryInterface {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, LoginResponseEntity>> getStoredUserData() async {
    try {
      final result = await authLocalDataSource.getCurrentUser();

      return Right(result);
    } on Exception catch (e) {
      log(e.toString());
      return Left(Failure("Erro desconhecido"));
    }
  }


  @override
  Future<Either<Failure, AuthResponseEntity>> getAccessToken(String username, String password) async {
    try {
      final result = await authRemoteDataSource.getAccessToken(username, password);
      return Right(result);
    } on DioError catch (e) {
      return Left(RestFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> login(LoginEntity authLoginEntity) async {
    try {
      final result = await authRemoteDataSource.login(authLoginEntity);
      return Right(result);
    } on DioError catch (e) {
      return Left(RestFailure(e.response?.data['message'] ?? "Erro ao realizar login"));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final response = await Future.wait([
        authLocalDataSource.cleanToken(),
      ]);

      return Right(
        response.any((element) => element),
      );
    } on Exception catch (e) {
      log("[AuthRepositoryImpl] logout: $e");
      return Left(Failure("Erro desconhecido"));
    }
  }


  @override
  Future<Either<Failure, bool>> storeAccessToken(String token) async {
    try{
      final result = await authLocalDataSource.setToken(token);
      return Right(result);
    } on Exception catch (e) {
      log("[AuthRepositoryImpl] storeAccessToken: $e");
      return Left(Failure("Erro Desconhecido"));
    }
  }

  @override
  Future<Either<Failure, String>> getStoredAccessToken() async {
    try {
      final result = await authLocalDataSource.getToken();

      return Right(result);
    } on Exception catch (e) {
      log("[AuthRepositoryImpl] getAccessToken: $e");
      return Left(Failure("Erro Desconhecido"));
    }
  }

  @override
  Future<Either<Failure, bool>> storeUserData(LoginResponseEntity loginResponseEntity) async {
    try{
      final result = await authLocalDataSource.setCurrentUser(loginResponseEntity);
      return Right(result);
    } on Exception catch (e) {
      log("[AuthRepositoryImpl] storeUserData: $e");
      return Left(Failure("Erro Desconhecido"));
    }
  }

}
