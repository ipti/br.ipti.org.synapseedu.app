import 'package:dartz/dartz.dart';

import '../../../../util/failures/failures.dart';
import '../../data/datasource/block_remote_datasource.dart';
import '../../data/model/block_model.dart';
import '../../data/repository/block_repository_interface.dart';
import '../entity/block_parameters_entity.dart';

class BlockRepositoryImpl extends IBlockRepository{
  final IBlockRemoteDataSource blockRemoteDataSource;

  BlockRepositoryImpl({required this.blockRemoteDataSource});

  @override
  Future<Either<Failure, BlockModel>> getBlock(BlockParameterEntity blockParameter) async {
    try {
      final block = await blockRemoteDataSource.getBlock(blockParameter);
      return Right(block);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}