
import 'package:dartz/dartz.dart';

import 'package:elesson/app/util/failures/failures.dart';

import '../../data/repository/performance_repository_interface.dart';
import '../../data/datasource/performance_remote_datasource.dart';
import '../../data/model/performance_model.dart';

class PerformanceRepositoryImpl extends IPerformanceRepository{
  final IPerformanceDatasource performanceDataSource;
  PerformanceRepositoryImpl({required this.performanceDataSource});

  @override
  Future<Either<Failure, Performance>> sendPerformanceAEL(Performance performance) async {
    try{
      Performance res = await performanceDataSource.sendPerformanceAEL(performance);
      return Right(res);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Performance>> sendPerformanceMTE(Performance performance) async {
    try{
      print("SEND PERFORMANCE");
      Performance res = await performanceDataSource.sendPerformanceMTE(performance);
      return Right(res);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Performance>> sendPerformancePRE(Performance performance) async {
    try{
      Performance res = await performanceDataSource.sendPerformancePRE(performance);
      return Right(res);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

}