import 'package:dio/dio.dart';
import '../interceptors/auth_interceptor.dart';

class DioAuthed {
  static final DioAuthed _singleton = DioAuthed._internal();

  final Dio dio = Dio()
    ..interceptors.addAll([
      AuthInterceptor(),
      // PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 90),
      // ErrorInterceptor()
    ])..options = BaseOptions(
      baseUrl: 'http://xpressapp.com.br:3009',
    );

  factory DioAuthed() {
    return _singleton;
  }

  DioAuthed._internal();
}
