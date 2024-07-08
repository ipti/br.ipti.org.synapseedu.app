import '../../domain/entity/block_parameters_entity.dart';
import '../mock/mock_block.dart';
import '../model/block_model.dart';
import 'package:dio/dio.dart';

abstract class IBlockRemoteDataSource {
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter);

  Future<List<BlockModel>> getBlockByTeacherId(int teacherId);
}

class BlockRemoteDataSourceMockImpl extends IBlockRemoteDataSource {
  final Dio dio;

  BlockRemoteDataSourceMockImpl({required this.dio});

  @override
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter) async {
    return BlockModel.fromJson(get_block_mock);
  }

  @override
  Future<List<BlockModel>> getBlockByTeacherId(int teacherId) {
    // TODO: implement getBlockByTeacherId
    throw UnimplementedError();
  }
}

class BlockRemoteDataSourceImpl extends IBlockRemoteDataSource {
  final Dio dio;

  BlockRemoteDataSourceImpl({required this.dio});

  @override
  Future<BlockModel> getBlock(BlockParameterEntity blockParameter) async {
    try {
      Response response = await dio.get('/block/break_points_in_current_year/${blockParameter.teacherId}/${blockParameter.studentId}/${blockParameter.disciplineId}');
      return BlockModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e.message);
      throw "${e.message}";
    }
  }

  @override
  Future<List<BlockModel>> getBlockByTeacherId(int teacherId) async {
    try {
      Response response = await dio.get('/block/by_teacher_id_in_current_year/${teacherId}');
      return (response.data as List).map((e) => BlockModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print(e.message);
      throw "${e.message}";
    }
  }
}
