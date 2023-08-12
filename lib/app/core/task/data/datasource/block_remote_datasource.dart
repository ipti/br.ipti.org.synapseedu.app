import 'package:dio/dio.dart';

import '../../domain/entity/block_parameters_entity.dart';
import '../mock/mock_block.dart';
import '../model/block_model.dart';

abstract class IBlockRemoteDataSource {
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter);
}

class BlockRemoteDataSourceImpl extends IBlockRemoteDataSource {
  final Dio dio;

  BlockRemoteDataSourceImpl({required this.dio});

  @override
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter) async {
    return BlockModel.fromJson(get_block_mock);
  }
}
