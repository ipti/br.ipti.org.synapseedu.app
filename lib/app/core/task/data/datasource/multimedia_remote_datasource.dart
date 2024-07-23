import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


abstract class IMultimediaRemoteDatasource {
  Future<String> getImageMultimediaReference(int multimediaId);

  Future<String> getTextById(int id);

  Future<List<int>> getBytesByMultimediaReference(String reference);

  Future<String> getTextOfImage(String base64Image, String googleApiToken);

  Future<String> getSoundByMultimediaId(int id);

  Future<Stream<Uint8List>> downloadSound(String nameAudio);
}

class MultimediaRemoteDataSourceImpl extends IMultimediaRemoteDatasource {
  final Dio dio;

  MultimediaRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> getImageMultimediaReference(int id) async {
    try {
      Response response = await dio.get('/multimedia/image/$id');
      return response.data['name'];
    } on DioException catch (e) {
      print(e.message);
      throw "${e.message}";
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
      throw "${e.message}";
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
      throw "${e.message}";
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
      throw "${e.message}";
    }
    throw "Erro desconhecido";
  }

  @override
  Future<String> getSoundByMultimediaId(int id) async {
    try {
      Response response = await dio.get('/multimedia/sound/$id');
      return response.data['name'];
    } on DioException catch (e) {
      print(e.message);
      throw "${e.message}";
    }
    throw "Erro desconhecido";
  }

  @override
  Future<Stream<Uint8List>> downloadSound(String nameAudio) async {
    try {
      Response<ResponseBody> response = await dio.post('/multimedia/download/sound', data: {"name": nameAudio}, options: Options(responseType: ResponseType.stream));
      return response.data!.stream;
    } on DioException catch (e) {
      print(e.message);
      throw "${e.message}";
    }
    throw ArgumentError.value("Download Audio", "Erro ao baixar o audio");
  }
}
