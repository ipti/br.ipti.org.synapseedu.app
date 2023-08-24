import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class IMultimediaRemoteDatasource {
  Future<String> getImageMultimediaReference(int multimediaId);

  Future<String> getTextById(int id);

  Future<List<int>> getBytesByMultimediaReference(String reference);

  Future<String> getTextOfImage(String base64Image, String googleApiToken);
}

class MultimediaRemoteDataSourceImpl extends IMultimediaRemoteDatasource {
  final Dio dio;

  MultimediaRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> getImageMultimediaReference(int id) async {
    try {
      if (kDebugMode) {
        dio.interceptors.removeWhere((element) => element.runtimeType == PrettyDioLogger);
      }
      Response response = await dio.get('/multimedia/image/$id');
      return response.data['name'];
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }

  @override
  Future<String> getTextById(int id) async {
    try {
      Response response = await dio.get('/multimedia/text/$id');
      return response.data['text']['description'];
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }

  @override
  Future<List<int>> getBytesByMultimediaReference(String reference) async {
    try {
      Response response = await dio.post<List<int>>("/multimedia/download/image", data: {"name": reference}, options: Options(responseType: ResponseType.bytes));
      return response.data;
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }

  @override
  Future<String> getTextOfImage(String base64Image, String googleApiToken) async {
    Dio dioCleaned = Dio();
    try {
      Response response = await dioCleaned.post(
        "https://vision.googleapis.com/v1/images:annotate",
        options: Options(
          headers: {'Authorization': googleApiToken},
          contentType: "application/json",
        ),
        data: {
          "requests": [
            {
              "image": {
                "content": base64Image,
              },
              "features": [
                {"type": "DOCUMENT_TEXT_DETECTION"}
              ]
            }
          ]
        },
      );
      print(response.data);
      return response.data["responses"][0]['textAnnotations'][0]['description'];
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }
}
