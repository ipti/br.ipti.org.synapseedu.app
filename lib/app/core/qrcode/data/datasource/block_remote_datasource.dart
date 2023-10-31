import '../../domain/entity/block_parameters_entity.dart';
import '../mock/mock_block.dart';
import '../model/block_model.dart';
import 'package:dio/dio.dart';

abstract class IBlockRemoteDataSource {
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter);
}

class BlockRemoteDataSourceMockImpl extends IBlockRemoteDataSource {
  final Dio dio;

  BlockRemoteDataSourceMockImpl({required this.dio});

  @override
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter) async {
    return BlockModel.fromJson(get_block_mock);
  }
}

class BlockRemoteDataSourceImpl extends IBlockRemoteDataSource {
  final Dio dio;

  BlockRemoteDataSourceImpl({required this.dio});

  @override
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter) async {
    try {
      Response response = await dio
          .get('/block/${blockParameter.teacherId}/${blockParameter.studentId}/${blockParameter.disciplineId}');
      return BlockModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e.message);
      throw "${e.message}";
    }
  }
}
