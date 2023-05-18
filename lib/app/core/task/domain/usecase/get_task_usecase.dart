import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/data/repository/task_repository_interface.dart';
import 'package:elesson/app/util/failures/failures.dart';

class GetTaskUseCase {
  final TaskRepositoryInterface taskRepository;

  GetTaskUseCase({required this.taskRepository});

  Future<Either<Failure, TaskModel>> getTaskById(int id) async {
    return await taskRepository.getTaskById(id);
  }
}