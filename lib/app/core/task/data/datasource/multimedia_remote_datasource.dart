import 'package:dio/dio.dart';

abstract class IMultimediaRemoteDatasource {
  Future<String> getImageMultimediaReference(int multimediaId);

  Future<String> getTextById(int id);

  Future<List<int>> getBytesByMultimediaReference(String reference);
}

class MultimediaRemoteDataSourceImpl extends IMultimediaRemoteDatasource {
  final Dio dio;

  MultimediaRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> getImageMultimediaReference(int id) async {
    try {
      Response response = await dio.get('/multimedia/image/$id');
      return response.data['name'];
    } on DioError catch (e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }

  @override
  Future<String> getTextById(int id) async {
    try {
      Response response = await dio.get('/multimedia/text/$id');
      return response.data['text']['description'];
    } on DioError catch (e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }

  @override
  Future<List<int>> getBytesByMultimediaReference(String reference) async {
    try{
      Response response = await dio.post<List<int>>("/multimedia/download/image", data: {"name": reference}, options: Options(responseType: ResponseType.bytes));
      return response.data;
    } on DioError catch(e) {
      print(e.message);
    }
    throw "Erro desconhecido";
  }
}
