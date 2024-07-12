import 'package:dartz/dartz.dart';
import 'package:elesson/app/util/failures/failures.dart';

import '../model/performance_model.dart';

abstract class IPerformanceRepository {
  Future<Either<Failure, Performance>> sendPerformanceMTE(Performance performance);

  Future<Either<Failure, Performance>> sendPerformancePRE(Performance performance);

  Future<Either<Failure, Performance>> sendPerformanceAEL(Performance performance);

}
