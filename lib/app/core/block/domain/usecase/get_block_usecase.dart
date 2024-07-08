import 'package:dartz/dartz.dart';
import '../../../../util/failures/failures.dart';
import '../../data/model/block_model.dart';
import '../../../task/data/repository/block_repository_interface.dart';
import '../entity/block_parameters_entity.dart';

class GetBlockUsecase{
  final IBlockRepository repository;

  GetBlockUsecase({required this.repository});

  @override
  Future<Either<Failure, BlockModel>> call(BlockParameterEntity params) async {
    return await repository.getBlock(params);
  }
}