import 'package:dio/dio.dart';
import '../../../../util/enums/task_types.dart';
import '../model/performance_model.dart';

abstract class IPerformanceRemoteDatasource {
  Future<Performance> sendPerformanceMTE(Performance performance);

  Future<Performance> sendPerformancePRE(Performance performance);

  Future<Performance> sendPerformanceAEL(Performance performance);
}

class PerformanceRemoteDatasource implements IPerformanceRemoteDatasource {
  final Dio dio;
  String url = '/performance';

  PerformanceRemoteDatasource({required this.dio});

  @override
  Future<Performance> sendPerformanceMTE(Performance performance) async {
    try {
      Response response = await dio.post(url, data: performance.toJson(templateType: TemplateTypes.MTE));
      return Performance.fromJson(response.data);
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro ao enviar performance";
  }

  @override
  Future<Performance> sendPerformancePRE(Performance performance) async {
    try {
      Response response = await dio.post(url, data: performance.toJson(templateType: TemplateTypes.PRE));
      return Performance.fromJson(response.data);
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro ao enviar performance";
  }

  @override
  Future<Performance> sendPerformanceAEL(Performance performance) async {
    try {
      Response response = await dio.post(url, data: performance.toJson(templateType: TemplateTypes.AEL));
      return Performance.fromJson(response.data);
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro ao enviar performance";
  }
}
