import 'package:elesson/app/core/task/domain/entity/block_parameters_entity.dart';
import '../../../../util/failures/failures.dart';
import '../model/block_model.dart';
import 'package:dartz/dartz.dart';

abstract class IBlockRepository {
  Future<Either<Failure, BlockModel>> getBlock(BlockParameterEntity blockParameter);
}