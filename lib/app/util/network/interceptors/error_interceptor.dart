import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elesson/app/core/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:elesson/app/core/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:elesson/app/core/auth/domain/entity/auth_entity.dart';
import 'package:elesson/app/core/auth/domain/repository/auth_repository_impl.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:elesson/app/util/network/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      debugPrint(err.message);
    }

    if (err.response != null && err.response!.statusCode == 401) {
      final authLocalDatasource = AuthLocalDatasourceImpl();
      final authRemoteDatasource = AuthRemoteDatasourceImpl(dio: Dio()..options.baseUrl = URLBASE);

      //limpando token antigo
      authLocalDatasource.cleanToken();

      AuthUseCase _authUseCase = AuthUseCase(authRepository: AuthRepositoryImpl(authRemoteDataSource: authRemoteDatasource, authLocalDataSource: authLocalDatasource));
      AuthEntity _webAppAuthEntity = AuthEntity(username: "editor", password: "iptisynpaseeditor2022");

      await _authUseCase.getAccessToken(_webAppAuthEntity);
      
      log(
        err.response?.data.toString() ?? err.message,
        stackTrace: err.stackTrace,
        error: err.error,
      );

      //TODO: alterar pra realizar navegação em caso de erros
      // navigatorKey.currentState!.setState(() {});
    }

    super.onError(err, handler);
  }
}
