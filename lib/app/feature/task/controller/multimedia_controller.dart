import 'package:dio/dio.dart';

class MultimediaController {
  Dio dio;

  MultimediaController({required this.dio});

  Future<List<int>> getBytesImage(String name) async {
    Response response = await dio.post<List<int>>("/multimedia/download/image", data: {"name": name}, options: Options(responseType: ResponseType.bytes));
    return response.data;
  }

  Future<String> getImageMultimedia(int multimediaID) async {
    Response response = await dio.get('/multimedia/image/$multimediaID');
    return response.data['name'];
  }

  Future<String> getTextMultimedia(int multimediaID) async {
    Response response = await dio.get('/multimedia/text/$multimediaID');
    return response.data['text']['description'];
  }
}
