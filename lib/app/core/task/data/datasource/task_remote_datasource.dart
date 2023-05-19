import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';

abstract class ITaskRemoteDataSource {
  Future<TaskModel?> getTaskById(int id);

}

class TaskRemoteDataSourceImpl extends ITaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSourceImpl({required this.dio});

  @override
  Future<TaskModel?> getTaskById(int id) async {
    final url = '/task/$id';

    try {
      Response response = await dio.get(url);
      TaskModel resTask = TaskModel.fromJson(response.data!);
      return resTask;
    } on DioError catch (e) {
      log("[GetTaskById]: ${e.response?.data}");
    }

    return null;
  }

}