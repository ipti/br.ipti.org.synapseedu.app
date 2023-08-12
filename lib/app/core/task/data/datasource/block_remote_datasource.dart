import '../../domain/entity/block_parameters_entity.dart';
import '../model/block_model.dart';

abstract class IBlockRemoteDataSource {
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter);
}

class BlockRemoteDataSourceImpl extends IBlockRemoteDataSource {
  @override
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter) async {
    return BlockModel.empty();
  }
}