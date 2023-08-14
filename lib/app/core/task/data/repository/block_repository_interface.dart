import '../../../../util/failures/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../qrcode/data/model/block_model.dart';
import '../../../qrcode/domain/entity/block_parameters_entity.dart';

abstract class IBlockRepository {
  Future<Either<Failure, BlockModel>> getBlock(BlockParameterEntity blockParameter);
}