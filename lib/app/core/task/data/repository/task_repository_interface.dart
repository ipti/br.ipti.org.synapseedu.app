import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/util/failures/failures.dart';

abstract class TaskRepositoryInterface{
  Future<Either<Failure, TaskModel>> getTaskById(int id);
}
