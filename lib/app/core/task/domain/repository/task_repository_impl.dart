import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/datasource/task_remote_datasource.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/data/repository/task_repository_interface.dart';
import 'package:elesson/app/util/failures/failures.dart';

class TaskRepositoryImpl extends ITaskRepository {
  final ITaskRemoteDataSource taskRemoteDataSource;

  TaskRepositoryImpl({required this.taskRemoteDataSource});

  @override
  Future<Either<Failure, TaskModel>> getTaskById(int id) async {
    try {
      final result = await taskRemoteDataSource.getTaskById(id);
      if (result != null) return Right(result);
    } on Exception catch (e) {
      return Left(Failure("Erro ao buscar tarefa"));
    }
    return Left(Failure("Erro desconhecido"));
  }
}
