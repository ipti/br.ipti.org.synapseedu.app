import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elesson/app/util/enums/task_types.dart';

import 'package:elesson/app/util/failures/failures.dart';

import '../../data/repository/performance_repository_interface.dart';
import '../../data/datasource/performance_remote_datasource.dart';
import '../../data/model/performance_model.dart';

class PerformanceRepositoryImpl extends IPerformanceRepository{
  final IPerformanceRemoteDatasource performanceRemoteDataSource;
  PerformanceRepositoryImpl({required this.performanceRemoteDataSource});

  @override
  Future<Either<Failure, Performance>> sendPerformanceAEL(Performance performance) {
    log(performance.toJson(templateType: TemplateTypes.AEL).toString());
    // TODO: implement sendPerformanceDDROP
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Performance>> sendPerformanceMTE(Performance performance) {
    log(performance.toJson(templateType: TemplateTypes.MTE).toString());
    // TODO: implement sendPerformanceMTE
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Performance>> sendPerformancePRE(Performance performance) {
    log(performance.toJson(templateType: TemplateTypes.PRE).toString());
    // TODO: implement sendPerformancePRE
    throw UnimplementedError();
  }


}