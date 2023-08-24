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
  Future<Either<Failure, Performance>> sendPerformanceAEL(Performance performance) async {
    try{
      Performance res = await performanceRemoteDataSource.sendPerformanceAEL(performance);
      return Right(res);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Performance>> sendPerformanceMTE(Performance performance) async {
    try{
      Performance res = await performanceRemoteDataSource.sendPerformanceMTE(performance);
      return Right(res);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Performance>> sendPerformancePRE(Performance performance) async {
    try{
      Performance res = await performanceRemoteDataSource.sendPerformancePRE(performance);
      return Right(res);
    } catch(e){
      return Left(Failure(e.toString()));
    }
  }

}