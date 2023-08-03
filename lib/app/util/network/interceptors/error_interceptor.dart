import 'package:elesson/app/core/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:elesson/app/feature/auth/auth_module.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

import '../../routes.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      debugPrint(err.message);
    }

    if (err.response != null && err.response!.statusCode == 401) {
      final authLocalDatasource = AuthLocalDatasourceImpl();
      // final authRemoteDatasource = AuthRemoteDatasourceImpl(dio: Dio()..options.baseUrl = URLBASE);
      // //limpando token antigo
      authLocalDatasource.cleanTokens();
      //
      // AuthUseCase _authUseCase = AuthUseCase(authRepository: AuthRepositoryImpl(authRemoteDataSource: authRemoteDatasource, authLocalDataSource: authLocalDatasource));
      // AuthEntity _webAppAuthEntity = AuthEntity(username: "editor", password: "iptisynpaseeditor2022");
      //
      // await _authUseCase.getAccessToken(_webAppAuthEntity);
      //
      // log(
      //   err.response?.data.toString() ?? err.message,
      //   stackTrace: err.stackTrace,
      //   error: err.error,
      // );

      //TODO: alterar pra realizar navegação em caso de erros
      log("ERRO 401, REDIRECIONANDO O USUARIO PARA LOGIN");
      print(navigatorKey.currentState);
      navigatorKey.currentState?.pushNamedAndRemoveUntil(AuthModule.routeName, (route) => false);
      // navigatorKey.currentState!.setState(() {});
    }

    super.onError(err, handler);
  }
}
