import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/error_interceptor.dart';

class DioAuthed {
  static final DioAuthed _singleton = DioAuthed._internal();

  final Dio dio = Dio()
    ..interceptors.addAll([
      AuthInterceptor(),
      if(kDebugMode) PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: true, error: true, compact: true, maxWidth: 90),
      ErrorInterceptor()
    ])..options = BaseOptions(
      baseUrl: URLBASE,
    );

  factory DioAuthed() {
    return _singleton;
  }

  DioAuthed._internal();
}
