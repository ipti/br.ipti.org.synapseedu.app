import 'package:dartz/dartz.dart' as Dartz;
import 'package:dio/dio.dart';
import 'package:elesson/app/core/task/data/datasource/multimedia_remote_datasource.dart';
import 'package:elesson/app/core/task/data/datasource/performance_remote_datasource.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/core/task/domain/repository/multimedia_repository_impl.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/task/page/task_view_page.dart';
import 'package:elesson/app/providers/block_provider.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';
import '../../core/task/data/datasource/task_remote_datasource.dart';
import '../../core/task/data/repository/performance_repository_interface.dart';
import '../../core/task/data/repository/task_repository_interface.dart';
import '../../core/task/domain/repository/performance_repository_impl.dart';
import '../../core/task/domain/repository/task_repository_impl.dart';
import '../../core/task/domain/usecase/get_task_usecase.dart';
import '../../core/task/domain/usecase/send_performance_usecase.dart';
import '../../util/failures/failures.dart';
import 'controller/task_view_controller.dart';

class TaskModule extends StatefulWidget {
  static const routeName = '/task-module';
  final TaskModel? taskModel;
  final int? taskId;

  const TaskModule({Key? key, this.taskModel, this.taskId}) : super(key: key);

  @override
  State<TaskModule> createState() => _TaskModuleState();
}

class _TaskModuleState extends State<TaskModule> {
  late IMultimediaRemoteDatasource _multimediaRemoteDataSource;
  late IPerformanceRemoteDatasource _performanceRemoteDataSource;
  late IMultimediaRepository _multimediaRepository;

  late IPerformanceRepository _performanceRepository;
  late MultimediaUseCase _getMultimediaUseCase;
  late SendPerformanceUseCase _sendPerformanceUseCase;

  late ITaskRemoteDataSource _taskRemoteDataSource;
  late ITaskRepository _taskRepository;
  late GetTaskUseCase _getTaskUseCase;

  late TaskViewController _taskViewController;
  late TaskModel task;

  late Soundpool soundpool;

  @override
  void initState() {
    super.initState();
    if (widget.taskModel != null) {
      task = widget.taskModel!;
    }

    Dio dioAuthed = DioAuthed().dio;
    _taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dioAuthed);
    _taskRepository = TaskRepositoryImpl(taskRemoteDataSource: _taskRemoteDataSource);
    _getTaskUseCase = GetTaskUseCase(taskRepository: _taskRepository);
    loadNextTask();

    _multimediaRemoteDataSource = MultimediaRemoteDataSourceImpl(dio: dioAuthed);
    _multimediaRepository = MultimediaRepositoryImpl(multimediaRemoteDataSource: _multimediaRemoteDataSource);
    _getMultimediaUseCase = MultimediaUseCase(multimediaRepository: _multimediaRepository);

    _performanceRemoteDataSource = PerformanceRemoteDatasource(dio: dioAuthed);
    _performanceRepository = PerformanceRepositoryImpl(performanceRemoteDataSource: _performanceRemoteDataSource);
    _sendPerformanceUseCase = SendPerformanceUseCase(performanceRepository: _performanceRepository);

    soundpool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.music));
  }

  void loadNextTask() async {
    BlockProvider blockProvider = Provider.of<BlockProvider>(context, listen: false);

    int? nextTaskId = blockProvider.nextTaskId;
    if (nextTaskId != null) {
      Dartz.Either<Failure, TaskModel> res = await _getTaskUseCase.getTaskById(nextTaskId);
      res.fold((l) => null, (r) => blockProvider.tasksLoaded.add(r));
    }
  }

  Future<void> preparingTask() async {
    int userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (widget.taskId != null) {
      Dartz.Either<Failure, TaskModel> res = await _getTaskUseCase.getTaskById(widget.taskId!);
      res.fold(
        (l) => null,
        (r) => task = r,
      );
    }
    _taskViewController = TaskViewController(
      sendPerformanceUseCase: _sendPerformanceUseCase,
      getMultimediaUseCase: _getMultimediaUseCase,
      soundpool: soundpool,
      userId: userId,
      task: task,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: preparingTask(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(color: Colors.white, child: Center(child: CircularProgressIndicator()));
          }
          return AnimatedBuilder(
            animation: _taskViewController,
            builder: (context, child) => TaskViewPage(taskViewController: _taskViewController, taskModel: task),
          );
        });
  }
}
