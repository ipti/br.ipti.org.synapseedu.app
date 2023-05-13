import 'package:dio/dio.dart';
import 'package:elesson/app/core/auth/data/datasource/local/auth_local_datasource.dart';

class AuthInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final sessionService = AuthLocalDatasourceImpl();
      final token = await sessionService.getToken();
      options.headers['Authorization'] = 'Bearer $token';

      return super.onRequest(options, handler);
    } catch (e) {
      return super.onRequest(options, handler);
    }
  }
}