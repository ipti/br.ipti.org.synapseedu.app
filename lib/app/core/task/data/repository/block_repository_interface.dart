import '../../../../util/failures/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../block/data/model/block_model.dart';
import '../../../block/domain/entity/block_parameters_entity.dart';

abstract class IBlockRepository {
  Future<Either<Failure, BlockModel>> getBlock(BlockParameterEntity blockParameter);
  Future<Either<Failure, List<BlockModel>>> getBlockByTeacherId(int teacherId);
}