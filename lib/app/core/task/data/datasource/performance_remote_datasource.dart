import 'package:dio/dio.dart';

import '../../../../util/enums/task_types.dart';
import '../model/performance_model.dart';

abstract class IPerformanceRemoteDatasource {
  Future<void> sendPerformanceMTE(Performance performance);

  Future<void> sendPerformancePRE(Performance performance);

  Future<void> sendPerformanceDDROP(Performance performance);
}

class PerformanceRemoteDatasource implements IPerformanceRemoteDatasource {
  final Dio dio;

  PerformanceRemoteDatasource({required this.dio});

  @override
  Future<void> sendPerformanceMTE(Performance performance) async {
    String url = '/performance/mte';
    try {
      await dio.post(url, data: performance.toJson(templateType: TemplateTypes.MTE));
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro ao enviar performance";
  }

  @override
  Future<void> sendPerformancePRE(Performance performance) async {
    String url = '/performance/pre';
    try {
      await dio.post(url, data: performance.toJson(templateType: TemplateTypes.PRE));
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro ao enviar performance";
  }

  @override
  Future<void> sendPerformanceDDROP(Performance performance) async {
    String url = '/performance/ddrop';
    try {
      await dio.post(url, data: performance.toJson(templateType: TemplateTypes.AEL));
    } on DioException catch (e) {
      print(e.message);
    }
    throw "Erro ao enviar performance";
  }
}
